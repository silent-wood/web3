const { ethers, deployments } = require("hardhat");
const { expect } = require("chai");

describe("TEST auction 721", function () {
  it("should be ok", async function() {
    await main();
  })
})

async function main() {
  // ethers.getSigners: 以太坊智能合约部署后，默认会有20个账户，这是用来获取账户的，这个账户是hardhat网络提供的测试账户
  const [signer, buyer] = await ethers.getSigners();
  // deployments.fixture: 用于运行一组特定的任务，["tag1", "tag2", ...]
  await deployments.fixture(["deployNftAuction"]);
  // deployments.get(contractName): 获取指定名称的合约部署信息， contractName: 部署时指定的名称，返回包含地址、ABI等信息的部署对象
  const nftAuctionProxy = await deployments.get("NftAuctionProxy");
  // ethers.getContractAt(contractName, address, signer?): 获取已部署合约的实例， contractName: 合约名称， address: 合约地址, signer: 可选，指定与合约交互的账户
  const nftAuction = await ethers.getContractAt(
    "NftAuction",
    nftAuctionProxy.address
  );

  // 获取测试用的ERC721合约
  const TestERC721 = await ethers.getContractFactory("TestERC721");
  // 部署测试用的ERC721合约
  const testERC721 = await TestERC721.deploy();
  // 等待部署完成
  await testERC721.waitForDeployment();
  // 获取部署后的ERC721合约地址
  const testERC721Address = await testERC721.getAddress();
  console.log("测试用ERC721合约地址：", testERC721Address);

  // 铸造10个NFT
  for(let i = 0; i < 10; i++) {
    await testERC721.mint(signer.address, i + 1);
  }
  // NFT 的 tokenId
  const tokenId = 1;
  // 给代理合约授权，允许代理合约转移用户的 NFT
  // setApprovalForAll(): ERC721 的批量授权函数
  // 第一个参数是操作者地址，第二个参数是是否授权

  await testERC721.connect(signer).setApprovalForAll(nftAuctionProxy.address, true);

  // 创建一个拍卖
  await nftAuction.createAuction(
    10, // 持续时间，单位是秒
    ethers.parseEther("0.01"), // 起拍价
    testERC721Address, // NFT合约地址
    tokenId // NFT的ID
  );

  console.log("拍卖创建成功");

  // 获取拍卖信息
  let auction = await nftAuction.auctions(0);
  console.log("拍卖信息：", auction);

  // 购买者出价
  await nftAuction.connect(buyer).playerBid(0, { value: ethers.parseEther("0.02") });

  // 结束拍卖
  // 等待10秒钟，确保拍卖时间到达
  await new Promise((resolve) => setTimeout(resolve, 10 * 1000));
  // 结束拍卖
  await nftAuction.connect(signer).endAuction(0);
  // 获取拍卖信息
  const auctionRes = await nftAuction.auctions(0);
  console.log("拍卖结果：", auctionRes);
  expect(auctionRes.highestBidder).to.equal(buyer.address);
  expect(auctionRes.highestBid).to.equal(ethers.parseEther("0.02"));


  // 检查NFT的归属
  const owner = await testERC721.ownerOf(tokenId);
  console.log("NFT归属：", owner);
  expect(owner).to.equal(buyer.address);
}