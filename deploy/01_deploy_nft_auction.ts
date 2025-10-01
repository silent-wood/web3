const { deployments, upgrades, ethers } = require("hardhat");
const fs = require("fs");
const path = require("path");

module.exports = async ({getNamedAccounts}) => {
  const { deploy, save } = deployments;
  const { deployer } = await getNamedAccounts();
  // 获取合约工厂
  const NftAuction = await ethers.getContractFactory("NftAuction");
  // 通过代理合约部署
  const NftAuctionProxy = await upgrades.deployProxy(NftAuction, [], { initializer: 'initialize' });
  // 等待部署完成
  await NftAuctionProxy.waitForDeployment();
  // 获取代理合约地址
  const proxyAddress = await NftAuctionProxy.getAddress();
  // 获取实现合约地址
  const implementationAddress = await upgrades.erc1967.getImplementationAddress(proxyAddress);
  console.log("代理合约地址：", proxyAddress);
  console.log("实现合约地址：", implementationAddress);
  // 将地址信息写入文件，方便后续脚本使用
  const storePath = path.resolve(__dirname, "./.cache/proxyNftAuction.json");
  // 如果目录不存在则创建
  const dir = path.dirname(storePath);
  if (!fs.existsSync(dir)) {
    fs.mkdirSync(dir, { recursive: true });
  }
  // 写入文件
  fs.writeFileSync(storePath, JSON.stringify({
    proxyAddress,
    implementationAddress,
    abi: NftAuction.interface.format("json")
  }, null, 2));

  await save("NftAuctionProxy", {
    abi: NftAuction.interface.format("json"),
    address: proxyAddress
  })

  // await deploy("NftAuction", {
  //   from: deployer,
  //   args: [],
  //   log: true,
  // });
};

module.exports.tags = ["deployNftAuction"];

