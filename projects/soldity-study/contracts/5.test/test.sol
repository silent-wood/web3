// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// contract Demo {
//     // test 返回100
//     function test() public pure returns(uint256 mul) {
//         uint256 a = 100;
//         mul = a;
//         return a;
//     }
// }

contract Utils {
    /**
     * 计算无符号整数数组的总和
     * @param numbers 无符号整数数组，长度任意
     * @return total 数组元素的总和
     */
    function sum(uint[] memory numbers) public pure returns (uint total) {
        total = 0;
        for (uint i = 0; i < numbers.length; i++) {
            total += numbers[i];
        }
        // return total; 这里不写return 也没关系
    }
}