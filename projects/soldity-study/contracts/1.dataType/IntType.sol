// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

import 'hardhat/console.sol';

contract IntType {
    // 初始化，定义或者声明
    // int 有符号，uint 无符号
    // intM: M 取值 8-256(位数，单位bits)， 步长为8, 8 16 24 ... 256
    int public x = 8;
    int public y;
    uint public ux = 16;
    uint public uy;
    
    function set(int m, uint n) public {
        y = m;
        uy = n;
    }

    function getUY() public view returns(uint) {
        return (ux << uy);
    }
    function getY() public view returns(uint) {
        require(uy < 256, unicode"y 必须小于256");
        // 位运算只对uint生效
        uint a = 8;
        return (a << uy);
    }
    function overflow() public pure {
        uint8 a = 255;
        a = a+1; // 整型溢出，整个transaction revert_
        console.log("a=%s", a);
    }
}