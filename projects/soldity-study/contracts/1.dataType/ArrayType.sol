// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;
import "hardhat/console.sol";
/**
* 引用类型，存储相同类型元素的有序集合
* 分为动态数组和静态数组，声明是需要指定存储位置
 */
contract ArrayType {
    // 状态变量中不需要加上存储位置，默认是storage, 
    // memory不能用于状态变量, 只能在函数中或者函数参数中使用
    // 静态数组的声明方式：T[size] [dataLocal] aryName
    uint[3] staticAry; // 初始值都是0
    // uint n = 2;
    // uint[n] staticAry1; // 这样是不合法的，因为n的值可能会发生改变
    // 静态数组初始化
    uint8[2] staticAry2 = [100,2]; // 静态数组的初始化
    uint[3] staticAry3 = [uint(100), 2, 3]; // 静态数组的初始化
    uint8[3] staticAry4 = [100, 2, 3]; // 静态数组的初始化
    uint8[3] staticAry5 = [uint8(1), 2, uint8(3)];
    uint[3] staticAry6 = [1,2];


    // 动态数组的声明方式：T[] [dataLocal] aryName
    // 只有使用storage修饰的动态数组可以用字面值初始化
    uint n = 3;
    uint[] dynamicAry;
    uint[] dynamicAry1 = new uint[](n);
    uint[] dynamicAry2 = [1,2,3];
    uint8[] dynamicAry3 = [1,3,4];
    uint8[] dynamicAry4 = [uint8(2)];
    uint[] dynamicAry5 = [uint(1), uint(2), uint(3)];
    function set() public pure {
        uint8[] memory dynamicAry6 = new uint8[](5);
        //  uint8[] memory dynamicAry7;
        //   dynamicAry7 = [uint8(1), uint8(2), uint8(3)];
        // uint8[] storage dynamicAry5 = [uint8(1),uint8(2),uint8(3)]; 这也会报错
        uint8[] memory dynamicAry7;
        dynamicAry7[0] = uint8(1);
        uint[] memory dynamicAry8 = new uint[](3);
        dynamicAry8[0] = 100;
        console.log(dynamicAry6.length, dynamicAry8.length);
    }

    // 数组切片(截取) ary.slice[start? : end?],含头不含尾,只能针对calldata的数组
    function arySlice(string calldata payload) public pure {
        string memory leading4Bytes = string(payload[:4]);
        console.log("leading 4 bytes: %s", leading4Bytes);
        // leading4Bytes[:]; 会报错，memory修饰的
    }

    function popAndPush() public {
        // 静态数组还是动态数组都有length属性
        console.log(dynamicAry5.length);
        console.log(staticAry2.length);
        // push末尾插入, pop末尾移除的前提是动态数组并且是storage的动态数组
        // staticAry2.push(); 这是静态数组
        dynamicAry5.push(4); // 这是动态数组，但是是memory的，不能push
        dynamicAry5.pop(); // 这是动态数组，但是是memory的，不能pop
        uint[] memory dynamicAry11 = new uint[](5);
        // dynamicAry11.push(1); memory的数组没有push和pop方法
    }
    

    // 多维数组
    // 静态多维数组 T[col][row] [dataLocal] aryName; row行 col列
    uint[3][4] mulSAry1; // 所有元素初始值为0
    uint[3][2] mulSAry2 = [[uint(1), 2, 3], [uint(4), 5, 6]];
    // uint[3][2] mulSAry3 = [[1, 2, 3], [uint(4), 5, 6]]; // 会报错，类型不一致
    uint[][3] mulSAry3;
    function invalidPush() public {
        uint k = 2;
        // mulSAry3.push(new uint[](k)); // 编译错误
        mulSAry3[0].push(999); // 这是合法的
    }
    // 动态多维数组 T[][] DataLocation arrName;
    uint[][] mulDAry1;
    function initArray() public {
        uint n = 2;
        uint m = 3;
        for(uint i = 0; i < n; i++){
            mulDAry1.push(new uint[](m));
        }
    }
}