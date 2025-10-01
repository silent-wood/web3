import { ethers } from "hardhat";

describe("NftAuction", async function () {
  it("Should create an auction", async function () {
    // 获取合约工厂
    const Contract = await ethers.getContractFactory("NFTAuction");
    // 合约部署
    const contract = await Contract.deploy();
    // 等待合约部署完成
    await contract.waitForDeployment();
    // 调用合约方法创建一个拍卖
    await contract.createAuction(
      100 * 1000,
      ethers.parseEther("0.000000000001"), // 0.000000000001 ETH
      ethers.ZeroAddress, // 0x0000000000000000000000000000000000000000
      1
    );

    const auction = await contract.auctions(0);

    console.log("Auction created:", auction);

  });
 
});