// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// 接口类似于抽象合约，但不实现任何具体功能
/**
* 1. 函数必须是 external, 且不能有函数体
* 2. 不可定义构造函数
* 3. 不能定义状态变量
* 4. 不可以声明修饰器
* 5. 不可以继承除接口外的其他合约
*/

// 例如：IERC20接口
// 参数中的indexed,表示会把from写入到日志的topic中，如果不加的话就是写入到Data中
interface IERC20SELF {
    // Tranfer事件，回执的日志里面打印 from, to, value
    event Transfer(address indexed from, address indexed to, uint256 value);
    // Approve事件，授权给spender
    event Approve(address indexed owner, address indexed spender, uint256 value);
    function totalSupply() external view returns (uint256);
    // 返回余额
    function balanceOf(address account) external view returns (uint256);
    // msg.sender 转账给 to代币,金额是value
    function transfer(address to, uint256 value) external returns (bool);
    // 
    function allowance(address owner, address spender) external view returns (uint256);
    // msg.sender授权给spender value的金额
    function approve(address spender, uint256 value) external returns (bool);
    // 从from那边转给to value金额
    function transferFrom(address from , address to, uint256 value) external returns (bool);
}

interface Name {
    event Test(address indexed from, address indexed to, uint256 value);
    function fn() external ;
}
// 接口继承
interface Name1 is Name {
    // 重写
    function fn(uint256 value) external ;
}
