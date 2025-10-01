const { ethers, upgrades } = require("hardhat");
const fs = require("fs");
const path = require("path");

module.exports = async ({ getNamedAccounts, deployments }) => {
  const { save } = deployments;
  const { deployer } = await getNamedAccounts();
  console.log("部署用户地址:", deployer);

  // 读取之前部署的代理合约地址
  const storePath = path.resolve(__dirname, "./.cache/proxyNftAuction.json");
  if (!fs.existsSync(storePath)) {
    throw new Error("找不到代理合约地址文件，请先运行部署脚本");
  }
  // 读取文件内容
  const storeData = fs.readFileSync(storePath, "utf-8");
  const { proxyAddress, implementationAddress, abi } = JSON.parse(storeData);

  // 获取升级后的合约工厂
  const nftAuctionV2 = await ethers.getContractFactory("NftAuctionV2");
  // 通过代理合约地址进行升级
  const nftAuctionV2Proxy = await upgrades.upgradeProxy(proxyAddress, nftAuctionV2);
  // 等待部署完成
  await nftAuctionV2Proxy.waitForDeployment();
  // 获取新的实现合约地址
  const proxyAddressV2 = await nftAuctionV2Proxy.getAddress();

  await save("NftAuctionProxyV2", {
    abi: nftAuctionV2.interface.format("json"),
    address: proxyAddressV2
  })
}

module.exports.tags = ["upgradeNftAuction"];