// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IAuthorizationManager {
    function verifyAuthorization(
        address vault,
        address recipient,
        uint256 amount,
        bytes32 nonce,
        bytes calldata signature
    ) external returns (bool);
}

contract SecureVault {
    IAuthorizationManager public immutable authManager;

    event Deposit(address indexed sender, uint256 amount);
    event Withdrawal(address indexed recipient, uint256 amount);

    constructor(address _authManager) {
        authManager = IAuthorizationManager(_authManager);
    }

    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(
        address recipient,
        uint256 amount,
        bytes32 nonce,
        bytes calldata signature
    ) external {
        require(
            authManager.verifyAuthorization(
                address(this),
                recipient,
                amount,
                nonce,
                signature
            ),
            "Authorization failed"
        );

        require(address(this).balance >= amount, "Insufficient vault balance");

        // Effects before interaction
        emit Withdrawal(recipient, amount);

        // Interaction
        (bool success, ) = recipient.call{value: amount}("");
        require(success, "ETH transfer failed");
    }
}
