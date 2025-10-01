// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

import "hardhat/console.sol";

/*
* 映射类型: mappping( keyType => valueType), keyType只能是内置的值类型， valueType: 可以是任意类型
* 只能声明在storage中
*/
contract MapType {
    // 声明一个映射类型
    mapping(address addr => uint amount) testMap;
    mapping(address addr => mapping(string => uint)) testMap1;

    // 映射类型作为函数入参时，函数可见性只能是private或者internal
    function addMap(mapping(address => uint) storage myMap) private {}
    function addMap1(address addr, uint value) private returns(uint) {
        testMap[addr] = value;
        return value;
    }

    function delMapping(address addr) public {
        delete testMap[addr];
        // delete testMap1[addr]["key"]; 嵌套mapping的删除方式
    }
    // function addMap(mapping(address => uint) storage myMap) public {} 可见性是public
}

contract MappingExample {
    mapping(address => uint) public balances;

    function update(uint newBalance) public {
        balances[msg.sender] = newBalance;
    }
}

contract MappingUser {
    function f() public returns (uint) {
        MappingExample m = new MappingExample();
        m.update(100);
        return m.balances(address(this));
    }
}