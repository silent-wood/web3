const { ethers, deployments, upgrades } = require("hardhat");
const { expect } = require("chai");

describe("Test upgrade", async function () {
  it("Should create an auction", async function () {
    // 1. 部署业务合约. deployNftAuction是部署脚本中的tag
    await deployments.fixture(["deployNftAuction"]);
    // NftAuctionProxy: 是部署脚本中save的合约名称，代理合约
    const nftAuctionProxy = await deployments.get("NftAuctionProxy");
    // 2. 通过业务合约创建一个拍卖, NftAuction: 是合约名称
    const nftAuction = await ethers.getContractAt("NftAuction", nftAuctionProxy.address);
    // 创建一个拍卖
    await nftAuction.createAuction(
      100 * 1000,
      ethers.parseEther("0.000000000001"), // 0.000000000001 ETH
      ethers.ZeroAddress, // 0x0000000000000000000000000000000000000000
      1
    );
    // 读取合约中的拍卖
    const auction = await nftAuction.auctions(0);
    // console.log(auction, "创建的拍卖");
    // 获取升级前的实现合约地址
    const implAddress1 = await upgrades.erc1967.getImplementationAddress(nftAuctionProxy.address);
    // 3. 升级业务合约 upgradeNftAuction: 是升级脚本中的tag
    await deployments.fixture(["upgradeNftAuction"]);
    // 获取升级后的代理合约
    const implAddress2 = await upgrades.erc1967.getImplementationAddress(nftAuctionProxy.address);
    console.log("升级前的实现合约地址:", implAddress1, "升级后的实现合约地址:", implAddress2);
    // 4. 读取合约中的拍卖
    const auction2 = await nftAuction.auctions(0);
    // 获取升级后的业务合约
    const nftAuctionV2 = await ethers.getContractAt("NftAuctionV2", nftAuctionProxy.address);
    // 调用升级后合约中的新方法
    const hello = await nftAuctionV2.testHello();
    console.log("升级后调用新方法 testHello():", hello);
    // 比较合约升级前后的拍卖信息是否一致：一致
    expect(auction2.startTime).to.equal(auction.startTime);
    // 升级前后实现合约地址是否一致：不一致的
    expect(implAddress1).to.not.equal(implAddress2);
  });
 
});