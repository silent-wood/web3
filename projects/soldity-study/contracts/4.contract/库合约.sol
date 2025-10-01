// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

/**
* 导入方式
* 通过文件位置导入
    * import "xxx.sol";
    * import { libraryName } from "xxx.sol"
    * import "xxx.sol" as libraryName;
    * import * as libraryName from "xxx.sol";
    * import { libraryName as newName } from "xxx.sol";
* npm 包的方式
* import "@openzepplein/contracts/access/Ownable.sol" 
* 通过网址引用
* import "https://github.com/Openzepplein/xxxxx.sol";
*/

/** 
* 库合约特性
    * 它们不能有状态变量
    * 它们不能继承，也不能被继承
    * 它们不能接收以太
    * 它们不能被销毁
*/

/**
* 库合约调用
    * z直接通过库合约签名调用，更节省gas
    * 使用using A for B 指令，这样库合约A中的函数会变成B类型的成员函数
*/

// using Strings for uint256;
// function getString1(uint256 _number) public pure returns(string memory) {
//     // 库合约中的函数会自动添加为uint256的成员
//     return _number.toHexString();
// }

// 直接通过库合约签名调用
// function getStrings(uint256 _number) public pure returns(string memory) {
//     return Strings.toHexString();
// }