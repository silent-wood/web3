// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

// 条件语句
contract Condition {
    // 返回引用类型也需要加上数据位置
    function ageStage(uint age) public pure returns(string memory) {
        string memory stage;
        if (age < 18) {
            stage = "teen";
        } else if (age < 65) {
            stage = "adult";
        } else {
            stage = "elderly";
        }
        return stage;
    }
}