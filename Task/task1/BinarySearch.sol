// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8;

contract BinarySearch {
  function search(uint256[] calldata array, uint256 target) public pure returns(int256) {
    // 空数组返回-1
    if (array.length == 0) {
      return -1;
    }

    uint256 left = 0;
    uint256 right = array.length - 1;

    while(left <= right) {
      uint256 mid = left + (right - left) / 2;
      // 如果中间的数值和目标值相等
      if (array[mid] == target) return int256(mid);
      // 如果中间值小于目标值，left 直接设置成mid + 1
      if (array[mid] < target) {
        left = mid + 1;
      } else {
        // 防止溢出
        if (mid == 0) break;
        right = mid - 1;
      }
    }
    return -1;
  }
}