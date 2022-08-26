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

  let allMintedTokenIds = await nftContract.getAllMintedTokens();
  console.log("all minted tokens", allMintedTokenIds);
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

// npx hardhat run scripts/run.js

// -- Contract --
// pay gas to mint
// which account does the fee go to?
// test get balance account
// map addresses to nfts
// user should be able to have multiple nfts
// add traits to nfts (sword, element, rarity)

// -- UI --
// connect wallet
// create mint function
// input to see a user's nfts
// show how many nfts the user has or how many are left
// gallery to see user's nfts
// gallery of all minted nfts
// loading states of mint transactions
// instructions on how to view nfts

// write tests
// out of funds error
// nfts depleted
// better security for private key
