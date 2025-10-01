// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

import "hardhat/console.sol";

contract StructType {
    struct Book {
        string title;
        uint price;
        // mapping(string => uint) myMapping;
    }
    // 放在外面是状态变量，需要用类似public private等修饰
    Book public book;
    // 这也是一种初始化的方式
    Book public book2 = Book('test title', 10);
    Book private book3;
    Book[] public bookList;
    constructor() {
        book = Book({
            title: 'my book',
            price: 25
        });
        book3.title = "private book";
        book3.price = 1;
    }

    function initBook1(string calldata title, uint price) public pure {
        Book memory book1 = Book({
            title: title,
            price: price
        });
        console.log("book title: %s, book price: %d", book1.title, book1.price);
    }

    function addNewBook(Book calldata newBook) public {
        bookList.push(newBook);
    }
}