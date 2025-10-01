// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "hardhat/console.sol";

// 地址类型：用于存放账户地址，保存20子节的值(一个以太坊地址的大小)
// address addr：不能直接发送以太币
// address payable addr1: 可直接发送以太币， 比上面的多了两个方法 transfer send
/** 
 * 以太坊中有两种账户类型
 * 外部账户(extenally owned address简称EOA): MateMask上创建的账户
 * 合约账户(contract address 简称CA): 部署合约后生成的地址
*/

contract AddrType {
    address addr = 0x690B9A9E9aa1C9dB991C7721a92d351Db4FaC990;
    address payable addr1 = payable(0x690B9A9E9aa1C9dB991C7721a92d351Db4FaC990);
    // addr1 可以隐式转换成 addr
    // addr需要使用payable才可以显示转换
    
    /** 
    * 地址类型的成员变量
    * balance: 账户地址的余额(wei)
    * code: 代码
    * codehash: 代码hash值
    */ 
    function getBalance() public view returns(uint) {
        return addr.balance; 
        // return address(this).balance; uint256
        // return address(this).code; bytes memory
        // return address(this).codehash; bytes32
    }

    /** 
    * 成员函数
    * <address payable addr>.transfer(uint256 amount): 向地址类型addr转账，数额为amount, 失败抛出异常
    * <address payable addr>.send(uint256 amount) returns (bool): 向地址类型addr发送amount的wei,返回布尔值
    * address.call(bytes memory) returns (bool, bytes memory): 调用其他合约的函数
    * address.delegatecall(bytes memory) returns (bool, bytes memory): 与call类似，但使用当前合约的上下文来调用其他合约中的函数，修改的是当前合约的数据存储。
    * address.staticcall(bytes memory) returns (bool, bytes memory): 与call类似，但是不会修改当前合约和调用的合约内部的状态 
    */
    function trans() public {
        // addr1.transfer(1);
        // addr1.send(1);
        // bool res = addr.call('1234');
    }
}