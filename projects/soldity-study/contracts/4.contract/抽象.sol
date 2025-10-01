// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// 抽象合约：允许包含至少一个未实现的函数，关键字是abstract, 没有实现的函数需要加上virtual关键字
abstract contract Feline {
    function utterance() public pure virtual returns (bytes32);
}

// 抽象合约不能被部署，但是可以被其他函数继承
contract Cat is Feline {
    function utterance() public pure override returns (bytes32) { return "miaow"; }
}