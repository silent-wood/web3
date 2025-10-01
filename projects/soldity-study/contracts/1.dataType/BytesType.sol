// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

import "hardhat/console.sol";

/** 
* 静态子节数组最多只能包含32个子节，且长度不可改变，属于值类型
* 动态子节数组长度可根据需要改变，属于引用类型
*/
// bytes: bytes 类型类似于一个 bytes1[] 数组，但其在内存（memory）和调用数据（calldata）中的存储更为紧凑。\
// 在 Solidity 的存储规则中，如 bytes1[] 这样的数组会要求每个元素占据 32 字节的空间或其倍数，不足 32 字节的部分会通过自动填充（padding）补齐至 32 字节。
// 然而，对于 bytes 和 string 类型，这种自动填充的要求并不存在，使得这两种类型在存储时能更加节省空间

// string 类型在内部结构上与 bytes 类型基本相同，但它不支持下标访问和长度查询。
// 换言之，尽管 string 和 bytes 在存储结构上一致，它们提供的接口却有所不同，以适应不同的用途
contract BytesType {
    function getBytes2() public pure returns(bytes2) {
        bytes2 i = bytes2(uint16(2));
        return i;
    }
    // bytes 和 string 转换
    // bytes -> string
    bytes bstr = new bytes(10);
    string message = string(bstr);
    // uint ll = message.length; 不合法，string没有length属性
    uint l2 = bstr.length;
    // string -> bytes
    string message1 = "hello world";
    bytes bstr1 = bytes(message1);
    uint l3 = bstr1.length; // 转换成bytes后可以获取length
}