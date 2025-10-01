// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

// 数据类型
contract BoolType {
    // 布尔类型
    bool public bool1;
    function boolType() public returns(bool) {
        bool1 = true;
        bool bool2 = !bool1;
        return bool2;
    }

}