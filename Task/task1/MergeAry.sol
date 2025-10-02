// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8;

contract MergeAry {
  constructor() {}

  function merge(uint256[] memory ary1, uint256[] memory ary2) public pure returns(uint256[] memory) {
    // 将两个有序数组合并为一个有序数组。
    uint len1 = ary1.length;
    uint len2 = ary2.length;
    uint len = len1 + len2;
    uint256[] memory result = new uint256[](len);
    uint i = 0;
    uint j = 0;
    uint k = 0;
    // 循环比较
    while(i < len1 && j < len2) {
      if (ary1[i] <= ary2[j]) {
        result[k++] = ary1[i++];
      } else {
        result[k++] = ary2[j++];
      }
    }
    // 比较剩余元素
    while(i < len1) {
      result[k++] = ary1[i++];
    }
    while(j < len2) {
      result[k++] = ary2[j++];
    }
    return result;
  }
}