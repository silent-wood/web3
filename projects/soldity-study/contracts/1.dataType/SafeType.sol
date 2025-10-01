// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

/** 
* 自定义值类型类似于别名，不具备原始类型的操作符(+,-,*,/等)
* 语法：type C(新类型) is V(原生类型)
*/
contract UserDefineType {
    type Weight is uint128;
    type Price is uint128;

    // 提高类型安全性
    Weight w = Weight.wrap(10);
    Weight w1 = Weight.wrap(20);
    Price p = Price.wrap(5);
    
    // 两个类型就不能进行运算,就算是同一个自定义值类型
    // Weight w0 = w + w1;
    // Weight wp = w * p;

    // 自定义值类型与原生类型之间相互转换
    // 原生类型 -> 自定义值类型
    Weight w2 = Weight.wrap(5);
    // 自定义值类型 -> 原生类型
    uint256 u = Weight.unwrap(w2); // 也可以是uintM,自定义值类型的时候是基于uint128
}