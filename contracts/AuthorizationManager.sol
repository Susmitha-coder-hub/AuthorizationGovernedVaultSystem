// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract AuthorizationManager {
    using ECDSA for bytes32;

    address public immutable signer;
    uint256 public immutable chainId;

    // authHash => used or not
    mapping(bytes32 => bool) public consumed;

    event AuthorizationConsumed(bytes32 indexed authHash);

    constructor(address _signer) {
        signer = _signer;
        chainId = block.chainid;
    }

    function verifyAuthorization(
        address vault,
        address recipient,
        uint256 amount,
        bytes32 nonce,
        bytes calldata signature
    ) external returns (bool) {
        bytes32 messageHash = keccak256(
            abi.encode(
                vault,
                chainId,
                recipient,
                amount,
                nonce
            )
        );

        bytes32 ethSigned = messageHash.toEthSignedMessageHash();

        require(!consumed[ethSigned], "Authorization already used");
        require(ethSigned.recover(signature) == signer, "Invalid signature");

        consumed[ethSigned] = true;

        emit AuthorizationConsumed(ethSigned);
        return true;
    }
}
