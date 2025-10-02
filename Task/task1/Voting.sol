// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract Voting {
    /** 候选人得票数 */
    mapping(string => uint256) votes;
    /** 所有候选人 */
    string[] candidates;
    /** 是否可以投票 */
    mapping(string => bool) private isCandidate;
    /** 管理员地址 */
    address admin;
    /** 构造函数，初始化候选人 */
    constructor(string[] memory _candidates) {
      admin = msg.sender;
      // 初始化候选人
      candidates = _candidates;
      uint256 len = _candidates.length;
      for (uint256 i = 0; i < len; i++) {
          isCandidate[_candidates[i]] = true;
          votes[_candidates[i]] = 0;
      }
    }

    /** 给候选人投票 */
    function vote(string calldata str, uint256 n) public {
      require(n > 0, "n must > 1");
      require(isCandidate[str], "Candidate must be exist");
      votes[str] += n;
    }
    /** 返回候选人的票数 */
    function getVotes(string calldata str) public view returns(uint256) {
      return votes[str];
    }
    /** 重置的票数 */
    function resetVotes() public {
      /** 只有管理员可以重置票数 */
      require(msg.sender == admin, "must be admin");
      for(uint256 i = 0; i < candidates.length; i++) {
          votes[candidates[i]] = 0;
      }
    }
}