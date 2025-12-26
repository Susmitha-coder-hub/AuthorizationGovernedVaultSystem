const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Secure Vault System", function () {
  it("Allows withdrawal only once per authorization", async function () {
    const [signer, user] = await ethers.getSigners();

    const Auth = await ethers.getContractFactory("AuthorizationManager");
    const auth = await Auth.deploy(signer.address);

    const Vault = await ethers.getContractFactory("SecureVault");
    const vault = await Vault.deploy(await auth.getAddress());

    await signer.sendTransaction({
      to: await vault.getAddress(),
      value: ethers.parseEther("1")
    });

    const nonce = ethers.keccak256(ethers.toUtf8Bytes("unique"));
    const msgHash = ethers.solidityPackedKeccak256(
      ["address", "uint256", "address", "uint256", "bytes32"],
      [await vault.getAddress(), 31337, user.address, ethers.parseEther("0.5"), nonce]
    );

    const signature = await signer.signMessage(ethers.getBytes(msgHash));

    await vault.withdraw(user.address, ethers.parseEther("0.5"), nonce, signature);

    await expect(
      vault.withdraw(user.address, ethers.parseEther("0.5"), nonce, signature)
    ).to.be.reverted;
  });
});
