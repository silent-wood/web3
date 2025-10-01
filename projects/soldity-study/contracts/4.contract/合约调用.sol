// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/interfaces/IERC20.sol";

contract ERC20Proxy {
    address delegate;

    constructor(address _delegate) {
        delegate = _delegate;
    }

    function balanceOf(address account) external view returns (uint256) {
        return IERC20(delegate).balanceOf(account);
    }

    // 示例：ERC20的msg.sender会变成当前合约
    function transferFrom(address from, address to, uint256 value) external returns(bool) {
        return IERC20(delegate).transferFrom(from, to, value);
    }

    function setVal(uint256 value) external pure {

    }

    function getVal() external view returns(uint256) {
        uint256 x = 1;
        return x;
    }

    // 通过call调用，合约地址.call(msg.data)
    function transferFrom1(address from, address to, uint256 value) external returns(bool) {
        (bool success, bytes memory data) = delegate.call(
            abi.encodeWithSignature("transferFrom1(address, address, value)", from, to)
        );
        assert(success);
        bool result = abi.decode(data, (bool));
        return result;
    }

    // staticcall调用,和call一致，只是限制了调用的函数的可变性只能是view/pure类型
    function transferFrom2(address from, address to, uint256 value) external returns(bool) { 
        (bool success, bytes memory data) = delegate.staticcall(
            abi.encodeWithSignature("transformFrom1(address, address, value)", from, to, value)
        );
    }

    function transferFrom3(address from, address to, uint256 value) external returns(bool) { 
        (bool success, bytes memory data) = delegate.delegatecall(
            abi.encodeWithSignature("transformFrom1(address, address, value)", from, to, value)
        );
        return success;
    } 

    // selfdestruct(address): 删除合约，并将剩余的以太币转移到指定地址
}