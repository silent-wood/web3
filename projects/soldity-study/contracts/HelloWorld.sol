// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract HelloWorld {
    string storeMsg;
    struct Book {
        string title;
        uint price;
    }
    function set(string memory message) public {
        storeMsg = message;
    }

    function get() public view returns(string memory) {
        return storeMsg;
    }
    string constant test = "1234";
}