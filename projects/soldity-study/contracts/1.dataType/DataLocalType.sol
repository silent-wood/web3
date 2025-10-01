// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;


/** 
* 引用类型的存储区域
* storage: 数据永久存储在区块链上，其生命周期与合约本身一致。类似为硬盘
* memory: 数据暂时存储在内存中，是易失的，其生命周期仅限于函数调用期间。 类似于RAM
* calldata: 类似于memory,用于存放函数参数，不可修改的，且比memory更节省gas
*/

contract DataLocalType {
    // 默认是storage, 唯一可以省略存储位置的地方
    uint[] x;

    // memoryArray 存储位置是memory
    function f(uint[] memory memoryArray) public {
        x = memoryArray; // 整个数组拷贝到storage， 赋值之后，memoryArray和x相互独立
        uint[] storage y = x; // 分配一个指针，其中 y 的数据存储位置是 storage
        y[7];
        y.pop();
        delete x; // 都会删除
    }
}