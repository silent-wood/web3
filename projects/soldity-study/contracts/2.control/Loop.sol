// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

contract Loop {
    function sumToN(int initial, int end) public pure returns(int) {
        int sum = 0;
        for(int i = initial; i < end; i++) {
            if (i >= end / 2) break;
            // if (1) 这样是不行的
            sum += i;
        }
        return sum;
    }
    function sumToN1(uint16 n) public pure returns(uint16) {
        uint16 sum = 0;
        uint16 i = 1; 
        while(i <= n) { //只改了这一行_
            sum += i;
            i++; // 修改循环变量的值_
        }
        return sum;
    }
    // do while循环至少执行一次
    function sumToN2(uint16 n) public pure returns(uint16) {
        uint16 sum = 0;
        uint16 i = 1; 

        do {
            sum += i;
            i++; // 修改循环变量的值_
        } while(i <= n); // 检查是否还满足循环条件_
        
        return sum;
    }
}