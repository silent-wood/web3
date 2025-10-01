# Sample Hardhat Project

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, and a Hardhat Ignition module that deploys that contract.

Try running some of the following tasks:

```shell
npx hardhat help
npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat node
npx hardhat ignition deploy ./ignition/modules/Lock.ts
```

## 在VS code中编写的合约可以在remixd中去验证
- 首先需要安装remixd插件
```bash
npm install -g @remix-project/remixd
```
具体内容见[remixd文档](https://remix-ide.readthedocs.io/zh-cn/latest/remixd.html)。
- remixd编辑器里中，左侧边栏下面的`plugins manager`中remixd插件打开
- vs code终端里面运行`npx hardhat`

## npx hardhat node
启动本地以太网开发网络，会分配20个账户

## npx hardhat ignition deploy ./ignition/modules/xxx.sol
在网络中部署 hardhat ignition 模块
如果在后面加上 `--network localhost`,则指定在哪个网络中部署，`localhost` 表示在本地网络部署，具体有哪些网络可以查看`hardhat.config.ts`中的`networks`模块。

## npx hardhat test
合约测试。在`test`目录下编写测试文件后，运行`npx hardhat test test/xxx.ts`。

# 合约部署
在开发过程中，合约都已经跟着项目跑了，但是每次测试的时候数据还是会初始化，所以这个时候需要对合约进行升级。  
需要借助`hardhat-deploy`插件来实现。[v1版本](https://github.com/wighawag/hardhat-deploy/tree/v1#readme)。 
## 安装 hardhat-deploy
```bash
npm install -D hardhat-deploy
```
## 使用hardhat-deploy
在`hardhat.config.js`中引入
```typescript
require("hardhat-deploy");
```
现在运行`npx hardhat`，可以在输出中看到已经挂载了一个`deploy`的task。  

## 安装`@openzeppelin/contracts-upgradeable`
```bash
npm install @openzeppelin/contracts-upgradeable
```
将原有合约继承自`openzeppelin/contracts-upgradeable`中的`Initializable`
```solidity
// 继承合约
contract NFTAuctionV2 is Initializable {
  // 去掉constructor
  // constructor() {
  //   admin = msg.sender;
  // }
  // 实现一个public函数initialize, 且加上initializer修饰器
  function initialize() public initializer {
    admin = msg.sender;
  }
}
```

编写文件`deploy/01_deploy_nft_auction.ts`
```ts
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
```
当运行 `npx hardhat deploy` 命令后，会生成一个文件，文件位置是`storePath`
-> npx hardhat deploy --tags xxx 这个命令可以部署一个特定的合约，xxx是机遇deploy文件夹中某个文件的module.exports.tags = ["xxx"];

## 合约升级
### 透明代理
- 首先需要实现一个升级合约的脚本
```ts
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
```
- 先在本地进行测试
```ts
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
```
- 运行测试脚本`npx hardhat test test/NftAuctionUpdate.ts`，看是否符合预期

### UUPS 代理
