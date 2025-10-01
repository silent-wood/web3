// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/**
* 函数重写/修饰器重写
    * 父类的函数必须使用virtual标识，子类中使用override来修饰
    * 函数可变性也可以修改：nopayable -> view -> public,左侧可以改成右侧的，payable不能修改
    * 函数可见性顺序只能从external改为public。可见性为private，不能重写
*/

/**
* 函数重载：多个同名，但参数类型或者个数不同
*    但是整型uint/int，bytes,
* 修饰器不能重载!!!
*/
contract A1 {
    modifier onlyOwner() virtual {_;}
    function foo() external virtual view {}

    // 重载
    function f(bytes1 value) public pure returns (bytes1 out) {
        out = value;
    }

    function f(bytes32 value, bool really) public pure returns (bytes32 out) {
        if (really)
            out = value;
    }
}

contract B1 is A1 {
    modifier onlyOwner() override {_;}
    function foo() public override view {}
}

// 多重继承
contract A2 {
    modifier onlyOwner() virtual {_;}
    function foo() virtual public {}
    function foo1() virtual public {}
}

contract B2 {
    modifier onlyOwner() virtual {_;}
    modifier onlyOwner1() virtual {_;}
    function foo() virtual public {}
}

contract C2 is A2, B2 {
    // 重写多个修饰器
    modifier onlyOwner() override(A2, B2) {_;}
    // 重写一个修饰器
    modifier onlyOwner1() override {_;}
    // 重写了多个父类中的方法，override(父类1,, 父类2)
    function foo() public override(A2, B2) {}
    // 重写一个
    function foo1() public override {}
}

contract Person {
    string internal name;
    uint256 age; // 状态变量可见性默认是internal

    event Log(string funName);

    modifier onlyOwner() virtual  {
        age = 1;
        _;
    }

    fallback() external payable virtual {
        emit Log("fallback by Person");
    }

    receive() external payable virtual  {
        emit Log("receive by Person");
    }
}

contract Man is Person {
    constructor() {
        name = "man";
        age = 20;
    }
    // 重载了Log事件
    event Log(string funName, address _ads);
    // 重写了修饰器
    modifier onlyOwner override {
        age = 99;
        _;
    }

    function getName() external view returns (string memory) {
        return name;
    }

    function getAge() external view returns (uint256) {
        return age;
    }

    fallback() external payable override {
        emit Log("fallback by man");
    }

    receive() external payable override {
        emit Log("receive by Man", msg.sender);
    }
}