// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// 实现一个简单的ERC721合约，用于测试拍卖合约
contract TestERC721 is ERC721Enumerable, Ownable {
  string private _tokenURI;

  constructor() ERC721("TestERC721", "TERC721") Ownable(msg.sender) {}

  function mint(address to, uint256 tokenId) public onlyOwner {
    _mint(to, tokenId);
  }

  function tokenURI(uint256 tokenId) public view override returns (string memory) {
    return _tokenURI;
  }

  function setTokenURI(string memory newTokenURI) public onlyOwner {
    _tokenURI = newTokenURI;
  }
}