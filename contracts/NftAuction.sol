// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "hardhat/console.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol"; // 导入ERC721合约
import { AggregatorV3Interface } from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol"; // 导入Chainlink价格预言机接口

contract NftAuction is Initializable, UUPSUpgradeable {
  // 结构体
  struct Auction {
    /** 卖家 */
    address seller;
    /** 持续时间 */
    uint256 duration;
    /** 起拍价 */
    uint256 startPrice;
    /** 开始时间 */
    uint256 startTime;
    /** 是否结束 */
    bool ended;
    /** 最高出价者 */
    address highestBidder;
    /** 最高价格 */
    uint256 highestBid;
    /** NFT合约地址 */
    address nftContract;
    /** NFT的tokenId */
    uint256 tokenId;
    /** 参与竞价的资产类型，0x: eth, 其他的表示erc20 */
    address tokenAddress;
  }

  // 状态变量
  /** id和卖家的映射 */
  mapping(uint256 => Auction) public auctions;
  /** 下一个拍卖ID */
  uint256 public nextAuctionId;
  /** 管理员地址 */
  address public admin;

  /** 价格预言机映射 */
  mapping(address => AggregatorV3Interface) public priceFeeds;

  // constructor() {
  //   admin = msg.sender;
  // }
  function initialize() public initializer {
    admin = msg.sender;
  }

  /** 设置Chainlink价格预言机 */
  function setPriceFeed(address tokenAddress, address _priceFeed) public {
    priceFeeds[tokenAddress] = AggregatorV3Interface(_priceFeed);
  }

  /** 获取Chainlink数据预言机最新价格 */
  function getChainlinkDataFeedLatestAnswer(address tokenAddress) public view returns (int) {
    AggregatorV3Interface priceETHFeed = priceFeeds[tokenAddress];
      (
          // uint80 roundId,
          int256 answer,
          // uint256 startedAt,
          // uint256 updatedAt,
          // uint80 answeredInRound
      ) = priceETHFeed.latestRoundData();
      return answer;
    }
  }

  /** 创建拍卖 */
  function createAuction(uint256 _duration, uint256 _startPrice, address _nftAddress, uint256 _tokenId) public {
    // 检查参数
    // 只有管理员才可以创建拍卖
    require(msg.sender == admin, "only admin");
    // 持续时间必须大于10秒
    require(_duration >= 10, "duration must be > 10 seconds");
    // 起拍价必须大于0
    require(_startPrice > 0, "startPrice must be > 0");

    // 转移NFT到合约地址
    // IERC721(_nftAddress).approve(admin, _tokenId);
    IERC721(_nftAddress).transferFrom(msg.sender, address(this), _tokenId);

    // 创建拍卖
    auctions[nextAuctionId] = Auction({
      seller: msg.sender,
      duration: _duration,
      startPrice: _startPrice,
      ended: false,
      highestBidder: address(0),
      highestBid: 0,
      startTime: block.timestamp,
      nftContract: _nftAddress,
      tokenId: _tokenId,
      tokenAddress: address(0)
    });
    nextAuctionId++;
  }

  // 买家出价
  function playerBid(uint256 _auctionId, uint256 amount, address _tokenAddress) public payable {
    // 检查拍卖是否存在
    Auction storage auction = auctions[_auctionId];
    // 判断当前拍卖是否结束, 只有在拍卖结束后才能出价
    require(!auction.ended && (auction.startTime + auction.duration > block.timestamp), "auction ended");
    
    uint payValue;
    if (_tokenAddress != address(0)) {
      // 处理erc20代币出价
      // 检查是否是ERC20代币
      payValue = amount * uint(getChainlinkDataFeedLatestAnswer(_tokenAddress));
    } else {
      // 处理ETH出价
      amount = msg.value;
      payValue = amount * uint(getChainlinkDataFeedLatestAnswer(address(0)));
    }

    uint startPriceValue = auction.startPrice * uint(getChainlinkDataFeedLatestAnswer(address(0)));
    uint highestBidValue = auction.highestBid * uint(getChainlinkDataFeedLatestAnswer(address(0)));
    // 出价必须大于当前最高价, 出价必须大于等于起拍价
    require(payValue >= highestBidValue && payValue >= startPriceValue, "bid must be >= startPrice");
    // 转移ERC20代币到合约
    if (_tokenAddress != address(0)) {
      // 处理erc20代币出价
      IERC20(_tokenAddress).transferFrom(msg.sender, address(this), amount);
    }

    // 退回之前最高出价者的金额
    if (auction.highestBid > 0) {
      if (auction.tokenAddress != address(0)) { // ERC20
        IERC20(auction.tokenAddress).transfer(auction.highestBidder, auction.highestBid);
      } else { // ETH
        payable(auction.highestBidder).transfer(auction.highestBid);
      }
    }
    auction.tokenAddress = _tokenAddress;
    // 更新最高出价者和最高出价
    auction.highestBidder = msg.sender;
    auction.highestBid = amount;
  }

  // 结束拍卖
  function endAuction(uint256 _auctionId) public {
    Auction storage auction = auctions[_auctionId];
    // 判断当前拍卖是否结束
    require(!auction.ended && (auction.startTime + auction.duration < block.timestamp), "auction not ended");
    // 转移NFT到最高出价者
    IERC721(auction.nftContract).transferFrom(admin, auction.highestBidder, auction.tokenId);
    // 转移剩余资金到卖家
    // payable(address(this)).transfer(address(this).balance);
    // 标记拍卖结束
    auction.ended = true;
  }

  // 身份验证，需要自己实现
  function _authorizeUpgrade(address newImplementation) internal override view {
    // 只有管理员才可以升级合约
    require(msg.sender == admin, "only admin can upgrade");
  }
}