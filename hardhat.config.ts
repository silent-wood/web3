import type { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

require('dotenv').config();
require("hardhat-deploy");
require("@openzeppelin/hardhat-upgrades"); 

const config: HardhatUserConfig = {
  solidity: "0.8.28",
  // defaultNetwork: "sepolia", // 在合约升级的时候，如果运行npx hardhat node命令的时候需要指定 --netowrk hardhat, 否则会报错,具体见[hardhat issue](https://github.com/wighawag/hardhat-deploy/issues/63)
  // 可以配置多个网络的信息，在部署的时候可以指定网络，比如：npx hardhat run scripts/deploy.ts --network sepolia 或者其他的网络
  networks: {
    sepolia: {
      // 对应测试网的RPC URL
      url: `https://sepolia.infura.io/v3/${process.env.INFURA_API_KEY}`,
      // 账户私钥
      accounts: [process.env.PRIVATE_KEY!, process.env.PRIVATE_KEY1!]
    },
    mainnet: {
      url: `https://mainnet.infura.io/v3/${process.env.INFURA_API_KEY}`,
      accounts: [process.env.PRIVATE_KEY!, process.env.PRIVATE_KEY1!]
    }
  },
  // // 在运行npx hardhat node的时候会生成20个账户，这里可以指定这些账户的别名，方便在脚本中使用
  namedAccounts: {
    deployer: {
      default: 0, // 默认情况下，使用第一个账户作为部署者
    },
    user1: {
      default: 1, // 第二个账户
    },
    user2: 2, // 第三个账户
  },
};

export default config;
