const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();

  console.log("Deployer:", deployer.address);
  console.log("Chain ID:", await deployer.provider.getNetwork().then(n => n.chainId));

  const AuthorizationManager = await hre.ethers.getContractFactory("AuthorizationManager");
  const authManager = await AuthorizationManager.deploy(deployer.address);
  await authManager.waitForDeployment();

  const SecureVault = await hre.ethers.getContractFactory("SecureVault");
  const vault = await SecureVault.deploy(await authManager.getAddress());
  await vault.waitForDeployment();

  console.log("AuthorizationManager:", await authManager.getAddress());
  console.log("SecureVault:", await vault.getAddress());
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
