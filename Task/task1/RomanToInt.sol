// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8;

contract Roman {
  constructor() {
  }

  function toInt(string memory roman) public pure returns(uint256) {
    bytes memory romanBytes = bytes(roman);
    uint256 result = 0;
    uint256 len = romanBytes.length;
    for(uint256 i = 0; i < len - 1; i++) {
      uint256 current = getVal(romanBytes[i]);
      uint256 next = getVal(romanBytes[i + 1]);
      if (current > next) {
        result += next;
      } else {
        result -= next;
      }
    }

    return result;
  }

  function getVal(bytes1 char) internal pure returns(uint) {
    if (char == 'I') return 1;
    if (char == 'V') return 5;
    if (char == 'X') return 10;
    if (char == 'L') return 50;
    if (char == 'C') return 100;
    if (char == 'D') return 500;
    if (char == 'M') return 1000;
    return 0;
  }
}