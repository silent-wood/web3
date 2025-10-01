// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract EnumType {
    enum ActionChoices {
        Left,
        Right,
        Top,
        Down
    }
    // 最大值和最小值
    function getMaxVal() public pure  returns(ActionChoices) {
        return type(ActionChoices).max; // 3
    }
    function getMinVal() public pure  returns(ActionChoices) {
        return type(ActionChoices).min; // 0
    }

    // 和整型转换
    function enumToUint(ActionChoices c) public pure returns(uint) {
        return uint(c);
    }

    function uintToEnum(uint i) public pure returns(ActionChoices) {
        return ActionChoices(i);
    }
}