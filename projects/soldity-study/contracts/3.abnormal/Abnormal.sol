// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;
import "hardhat/console.sol";

contract Abnormal {
    error Unauthorized();
    // require: 通常用于验证外部输入、处理条件和确认合约的交互符合预期
    // 检查失败，会撤销所有修改并退还剩余的 gas。
    function requireErr(uint amount) public pure {
        console.log(amount, "amount");
        // 条件不满足：函数停止执行，抛出异常，触发状态回滚
        require(amount % 2 == 0, "Even value amount");
        console.log(amount / 2, "222");
    }
    // assert: 用于检查代码逻辑中不应发生的情况，主要是内部错误
    // assert 失败将消耗所有提供的 gas，并回滚所有修改。
    function assertErr(address payable addr1, address payable addr2) public payable {
        require(msg.value % 2 == 0, "Even value required."); // 检查传入的ether是不是偶数
        uint balanceBeforeTransfer = address(this).balance;
        addr1.transfer(msg.value / 2);
        addr2.transfer(msg.value / 2);
        assert(address(this).balance == balanceBeforeTransfer); // 检查分账前后，本合约的balance不受影响_
    }
    // revert: 异常处理并撤销所有状态变化, 不需要条件直接抛出异常，不会被记录到链上
    function revertErr(uint amount) public pure {
        // revert 语句：revert CustomError(arg1, arg2); 或者 revert("My Error string");
        if (amount % 2 == 0) { // 检查传入的ether是不是偶数_
            // revert("Even value revertd.");
            revert Unauthorized();
        }
        console.log(amount / 2, unicode"对半分");
    }

    // try catch 捕获错误, 在外部合约调用的时候或者构造函数的调用，返回值可选
    // try externamContract.f() [returns (returnType val)] {
    //      call成功逻辑
    // } catch {
    //      call 失败逻辑
    // }
}