// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

/** 
* receive函数
    * 用来接收以太币转账的函数
    * 格式固定: receive() external payable modifers {} 不能有参数，不能有返回值，可以有修饰器，可以重写
*/
contract Callee {
    modifier onlySelf() {
        _;
    }
    /** 
    * 当外部调用的函数不存在，receive函数也不存在的时候兜底
    * 固定格式：fallback() external payable
    */
    fallback() external payable { }
    receive() external payable onlySelf { }
}

contract Caller {
    address payable callee;
    constructor() {
        // address(new Callee()) 是一个地址类型，而callee声明的时候是payable修饰了，所以初始化需要使用payable进行显示转换
        callee = payable(address(new Callee()));
    }


    /** 
    * receive函数只能接口
    */
    /** 
    * 转账的三种方式
        * Contract.transfer(value): 向Contract发送value数量的以太币，固定2300gas，错误时会 revert。
        * Contract.send(value): 向Contract发送 value 数量的以太币，固定使用 2300 gas，错误时不会revert，返回布尔值表示结果,可以手动revert
        * Contract.call{value: amount, gas: gasVal}(): 向Contract发送 amount 数量的以太币，gas 可以自由设定，返回布尔值表示成功或失败
    */
    /** 
    * 超过2300gas的情况
        * 修改状态变量
        * 创建合约
        * 调用其他相对复杂的函数
        * 发送以太币到其他账户
    */
    function transfer() external  {
        callee.transfer(1);
    }

    function trySend() external {
        bool success = callee.send(1);
        require(success, "faild to send");
    }

    function tryCall() external {
        // 两种写法都可以
        // (bool success, bytes memory data) = callee.call{ value: 1 };
        (bool success,) = callee.call{ value: 1 }("");
        // 下面的方式也可以，但是需要加上 import "openzeppelin/contracts/utils/Address.sol";
        // Address.sendValue(callee, 1);

        require(success, 'fail to send');
    }
}

contract Callee1  {
    event FunctionCalled(string);

    function foo() external payable  {
        emit FunctionCalled("this is foo");
    }
    receive() external payable { 
        emit FunctionCalled("this is receive");
    }
    fallback() external payable {
        emit FunctionCalled("this is fallback");
    }
}

contract Caller1 {
    address payable callee;

    constructor() payable {
        callee = payable(address(new Callee1()));
    }
    // 触发 receive 函
    function transferReceive() external {
        callee.transfer(1); // 会触发receive
    }
    // 触发 receive 函
    function sendReceive() external {
        bool success = callee.send(1);
        require(success, "fail to send");
    }
    // 触发 receive 函
    function callReceive() external {
        (bool success, bytes memory data) = callee.call{value: 1}("");
        require(success, "Failed to send Ether");
    }
    // 触发 foo 函数
    function callFoo() external {
        (bool success, bytes memory data) = callee.call{value: 1}(
            abi.encodeWithSignature("foo()")
        );
        require(success, "Failed to send Ether");
    }
    // 触发 fallback 函数，因为 funcNotExist() 在 Callee 没有定义
    function callFallback() external {
        (bool success, bytes memory data) = callee.call{value: 1}(
            abi.encodeWithSignature("funcNotExist()")
        );
        require(success, "Failed to send Ether");
    }
}

