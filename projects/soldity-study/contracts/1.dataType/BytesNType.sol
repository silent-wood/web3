// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "hardhat/console.sol";
/** 
* 静态字节数组：bytes1, bytes2, ... bytes32,属于值类型，定义后有固定长度
*/
contract BytesType {
    bytes2 a;
    bytes4 b;
    function getBytes2() public view returns (bytes2) {
        return a;
    }
    function getBytes4() public view returns (bytes4) {
        return b;
    }
    function setBytes2(bytes2 x) public {
        //  0x0001
        a = x;
        console.log("a.length: ", a.length);
    }
    function setBytes4(bytes4 y) public {
        // 0x00000011
        b = y;
        console.log(unicode"b.length 长度 ", b.length);
    }
}