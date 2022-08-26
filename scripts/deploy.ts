import { ethers } from "hardhat";

const main = async () => {
  const [deployer] = await ethers.getSigners();
  const nftContractFactory = await ethers.getContractFactory("OrigamiNFT");
  const nftContract = await nftContractFactory.deploy();
  await nftContract.deployed();

  console.log("Contract deployed to:", nftContract.address);

  let txn = await nftContract.mintOrigamiNFT();
  await txn.wait();

  console.log("nft #1 minted");

  txn = await nftContract.mintOrigamiNFT();
  await txn.wait();
  console.log("nft #2 minted");

  console.log("deployer address", deployer.address);

  let returnedArray = await nftContract.getTokensByAddress(deployer.address);
  console.log("holder tokens", returnedArray);
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();

// npx hardhat run scripts/deploy.ts --network rinkeby
