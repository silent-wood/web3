// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

contract Bank {
    // 定义一个address类型的owner变量
    address payable owner;
    // 事件
    event Deposit(address _ads, uint256 amount);
    event Withdraw(uint256 amount);

    // 修饰器
    modifier onlyOwner() {
        require(msg.sender == owner, "not owner");
        _;
    }
    // 接受转账
    receive() external payable { 
        emit Deposit(msg.sender, msg.value);
    }
    // 构造函数
    constructor() {
        owner = payable(msg.sender);
    }
    // 取钱
    function withdraw() external onlyOwner {
        emit Withdraw(address(this).balance);
        selfdestruct(payable(msg.sender));
    }
    function getBanlance() public view returns(uint256) {
        return address(this).balance;
    }
}
