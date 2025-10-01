// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Owner {
    // 结构体
    struct Identity {
        address addr;
        string name;
    }

    // 枚举
    enum State {
        HasOwner,
        NoOwner
    }

    // 事件
    event OwnerSet(address indexed oldOwnerAddress, address indexed newOwnerAddress);
    event OwnerRemoved(address indexed oldOwnerAddress);

    // 状态
    Identity private owner;
    State private state;
    int8 n;

    // 修饰器
    modifier isOwner() {
        require(msg.sender == owner.addr, "caller is not owner");
        _;
    }

    // 构造函数
    constructor(string memory name) {
        owner.addr = msg.sender;
        owner.name = name;
        state = State.HasOwner;
        emit OwnerSet((address(0)), owner.addr);
    }

    // 普通函数
    function changeOwner(address addr, string calldata name) public isOwner {
        owner.addr = msg.sender;
        owner.name = name;
        state = State.HasOwner;
        emit OwnerSet(owner.addr, addr);
    }

    function removeOwner() public isOwner {
        emit OwnerRemoved(owner.addr);
        delete owner;
        state = State.NoOwner;
    }

    function getOwner() external view returns (address, string memory) {
        return (owner.addr, owner.name);
    }

    function getState() external view returns (State) {
        return state;
    }

}