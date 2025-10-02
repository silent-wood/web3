// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8;

contract ReverseString {
    // string 是没有length属性的，需要转换成bytes类型
    // bytes类型是动态数组，可以通过length属性获取长度
    // bytes类型和string类型之间的转换不会改变数据，只是类型不同
    function reverse(string memory str) public pure returns (string memory) {
      // 交换法反转
        bytes memory strBytes = bytes(str);
        // 获取字符串长度
        uint256 len = strBytes.length;
        // 逐个字符进行交换
        for (uint256 i = 0; i < len / 2; i++) {
            // 交换字符
            (strBytes[i], strBytes[len - i - 1]) = (strBytes[len - i - 1], strBytes[i]);
        }
        return string(strBytes);
    }
    function reverse1(string memory str) public pure returns (string memory) {
        // 逐个字符反转
        bytes memory strBytes = bytes(str);
        // 获取字符串长度
        uint256 len = strBytes.length;
        // 创建一个新的字节数组用于存储反转后的字符串
        bytes memory result = new bytes(len);
        // 逐个字符进行反转
        for (uint256 i = 0; i < len; i++) {
            result[i] = strBytes[len - i - 1];
        }
        // 返回反转后的字符串
        return string(result);
    }
}