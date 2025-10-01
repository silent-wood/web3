import { expect } from "chai";
import { describe } from "mocha";

const hre = require("hardhat");

describe("MyToken", async () => {
  const { ethers } = hre;
  let myToken, myTokenContract;
  let account1, account2;
  let initialSupply = 10;
  beforeEach(async () => {
    // getSigners 方法可以获取测试账户,具体数量需要看配置文件中配置的私钥数量
    [account1, account2] = await ethers.getSigners();
    // 工厂函数
    myToken = await ethers.getContractFactory("MyToken");
    // 部署合约,connect指定用哪个账户部署
    myTokenContract = await myToken.connect(account2).deploy(initialSupply);
    // 等待合约部署完成
    await myTokenContract.waitForDeployment();
    // 获取合约地址
    const myContractAddress = await myTokenContract.getAddress();
    expect(myContractAddress).to.length.greaterThan(0);
  });

  // it("验证合约", async () => {
  //   const name = await myTokenContract.name();
  //   const symbol = await myTokenContract.symbol();
  //   const decimals = await myTokenContract.decimals();
  //   expect(name).to.equal("MyToken");
  //   expect(symbol).to.equal("MTK");
  // });
  it("测试转账", async () => {
    const balance1 = await myTokenContract.balanceOf(account1);
    const balance2 = await myTokenContract.balanceOf(account2);
    expect(balance2).to.equal(initialSupply); // 部署账户余额等于初始发行量
    expect(balance1).to.equal(0);

    // account2 给 account1 转账 一半的 代币
    // const value = initialSupply / 2;
    // console.log(value, "value", initialSupply);
    try {
      const resp = await myTokenContract.transfer(account1, initialSupply / 2);
      await resp.wait(); // 等待上链之后余额才会更新
      const b1n = await myTokenContract.balanceOf(account1);
      const b2n = await myTokenContract.balanceOf(account2);
      expect(b2n).to.equal(b1n);
      expect(b1n).to.equal(initialSupply / 2);
      expect(b2n).to.equal(initialSupply / 2);
    } catch (error) {
      console.error(error);
    }
  });
});
