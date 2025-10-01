// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "hardhat/console.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "./NftAuction.sol";

// 升级版的业务合约
contract NftAuctionV2 is NftAuction {
  function testHello() public pure returns (string memory) {
    return "Hello World";
  }
}