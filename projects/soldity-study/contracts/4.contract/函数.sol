// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "hardhat/console.sol";

contract FunctionContract {
    address public owner;
    uint n;
    modifier selfModifer() {
        console.log(msg.sender, 'sender');
        require(msg.sender == owner, "Only the owner can call this function.");
        _;
    }

    modifier selfModirer1() {
        console.log('selfModifer');
        require(n == 1, "n must = 1");
        _;
    }
    
    modifier testUnit(uint a) {
        require(a > 0, "a must > 0");
        _;
    }

    constructor(uint x) {
        n = x;
        owner = msg.sender;
    }

    // 在returns中已经定义了返回变量了，所以可以不写return
    function returnFn() public pure returns(uint a, uint b) {
        uint x = 100;
        uint y = 10;
        a = x;
        b = y;
    }

    // 返回多个参数可以这样写
    function returnFn1() public pure returns(uint a, uint b) {
        return (1, 2);
    }

    /*
    * function fn: 声明函数fn
    * parameter: 参数列表 (uint a, uint b)
    * visiblitity: 函数可见性,访问范围
      * public: 无限制访问
      * private: 当前合约
      * internal: 合约内部和继承的合约
      * external: 仅限于外部调用，优化gas
    * state mutability： 状态可变性，函数是否会修改或读取合约的状态， 可选
      * pure：不读取不修改状态
      * view: 只读取不修改
      * payable：可以接受以太币
    * modifiers： 函数修饰器，可以多个 可选
    * returns (return-list)： 返回值类型
    */

    /** 
    * 查询合约的情况
      * 读取状态变量
      * 访问余额：address(this).balance访问合约的余额，<address>.balance获取任何地址的以太余额
      * 访问区块链特性：通过block,tx,msg等全局变量的成员访问区块链的特定属性，具体见：https://docs.soliditylang.org/zh-cn/latest/units-and-global-variables.html
      * 调用非pure函数
      * 使用内联汇编
    */

    /**
    * 修改合约状态
      * 修改状态变量
      * 触发日志
      * 创建其他合约
      * 使用selfdestruct销毁合约
      * 通过函数发送以太币
      * 调用非pure和view的函数
      * 使用低级调用，如call、delegatecall、staticcall等，因为他们允许与其他合约交互
      * 使用含有特定操作码的内联汇编
    */
    function fn(uint a, uint b) public view selfModifer returns(uint) {
        return a + b;
    }

    // 多个修饰器，且修饰器可以传参
    function fn1() public view selfModifer selfModirer1 testUnit(n) {
        console.log("fn1");
    }

}