// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract ConstAndImmutable {
    // constant声明的变量只能在声明时定义，且不可以修改
    string constant myString = "123";
    // constant声明的必须是值类型
    // uint[3] constant myUints = [1, 2, 3];

    // immutable可以先声明后定义或者直接声明赋值，部署前可变，部署后不可变
    uint immutable myUint; // 先声明那只能在在构造函数中初始化
    uint immutable myUint1 = 4;

    constructor() {
        myUint = 3;
        myUint1 = 5; // 合约初始化的时候执行，可以修改，在函数中不可以修改
    }
}