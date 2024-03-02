// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DPoSContracts {
    struct Delegate {
        uint256 voteCount;
        bool isDelegate;
        uint256 lastBlockNumber; // Simulated last block "created"
    }

    address public admin;
    mapping(address => Delegate) public delegates;
    mapping(address => address) public voterToDelegate;
    mapping(address => uint256) public stakes;

    uint256 public minimumStakeRequirement;

    event DelegateAdded(address indexed delegate);
    event VoteCasted(address indexed voter, address indexed delegate, uint256 votes);
    event VoteRevoked(address indexed voter, address indexed delegate, uint256 votes);
    event StakeDeposited(address indexed staker, uint256 amount);
    event StakeWithdrawn(address indexed staker, uint256 amount);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action.");
        _;
    }

    constructor(uint256 _minimumStakeRequirement) {
        admin = msg.sender;
        minimumStakeRequirement = _minimumStakeRequirement;
    }

    function addDelegate(address _delegate) external onlyAdmin {
        require(!delegates[_delegate].isDelegate, "Address is already a delegate.");
        delegates[_delegate].isDelegate = true;
        delegates[_delegate].voteCount = 0;
        emit DelegateAdded(_delegate);
    }

    function depositStake() external payable {
        require(msg.value >= minimumStakeRequirement, "Deposit does not meet the minimum stake requirement.");
        stakes[msg.sender] += msg.value;
        emit StakeDeposited(msg.sender, msg.value);
    }

    function withdrawStake(uint256 amount) external {
        require(stakes[msg.sender] >= amount, "Insufficient stake to withdraw.");
        stakes[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
        emit StakeWithdrawn(msg.sender, amount);
    }

    function voteForDelegate(address _delegate, uint256 _votes) external {
        require(delegates[_delegate].isDelegate, "Not a valid delegate.");
        require(_votes <= stakes[msg.sender], "Voting more than staked amount.");

        if (voterToDelegate[msg.sender] != address(0)) {
            revokeVote(voterToDelegate[msg.sender]);
        }

        voterToDelegate[msg.sender] = _delegate;
        delegates[_delegate].voteCount += _votes;
        emit VoteCasted(msg.sender, _delegate, _votes);
    }

    function revokeVote(address _delegate) public {
        require(voterToDelegate[msg.sender] == _delegate, "You did not vote for this delegate.");
        
        uint256 votesToRevoke = stakes[msg.sender];
        delegates[_delegate].voteCount -= votesToRevoke;
        emit VoteRevoked(msg.sender, _delegate, votesToRevoke);

        voterToDelegate[msg.sender] = address(0); // Reset the voter's delegate
    }
}
