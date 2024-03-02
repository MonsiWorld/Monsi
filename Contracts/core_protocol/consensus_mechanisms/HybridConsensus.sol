// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title HybridConsensus
 * @dev Extended version to include simulated PoW reward logic and admin functionalities.
 */
contract HybridConsensus {
    address public admin;
    uint256 public stakeRequirement;
    uint256 public currentDifficulty;
    mapping(address => uint256) public stakes;

    // Adding a simple reward mechanism
    uint256 public constant REWARD = 1 ether;
    mapping(address => uint256) public rewards;

    event StakeDeposited(address indexed staker, uint256 amount);
    event StakeWithdrawn(address indexed staker, uint256 amount);
    event WorkValidated(address indexed worker, uint256 difficulty, uint256 reward);
    event DifficultyAdjusted(uint256 newDifficulty);
    event StakeRequirementAdjusted(uint256 newStakeRequirement);

    modifier onlyAdmin() {
        require(msg.sender == admin, "HybridConsensus: Only admin can perform this action.");
        _;
    }

    constructor(uint256 _stakeRequirement, uint256 _initialDifficulty) {
        admin = msg.sender;
        stakeRequirement = _stakeRequirement;
        currentDifficulty = _initialDifficulty;
    }

    function depositStake() external payable {
        require(msg.value >= stakeRequirement, "HybridConsensus: Deposit does not meet the stake requirement.");
        stakes[msg.sender] += msg.value;
        emit StakeDeposited(msg.sender, msg.value);
    }

    function withdrawStake(uint256 amount) external {
        require(stakes[msg.sender] >= amount, "HybridConsensus: Insufficient stake.");
        stakes[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
        emit StakeWithdrawn(msg.sender, amount);
    }

    function validateWork(uint256 nonce) external {
        bytes32 hash = keccak256(abi.encodePacked(block.number, msg.sender, nonce));
        bytes32 target = bytes32(type(uint256).max >> currentDifficulty);

        require(hash < target, "HybridConsensus: Work does not meet the difficulty requirement.");
        
        // Simulated reward distribution logic
        rewards[msg.sender] += REWARD;
        emit WorkValidated(msg.sender, currentDifficulty, REWARD);
    }

    // Allows miners to claim their rewards
    function claimReward() external {
        uint256 reward = rewards[msg.sender];
        require(reward > 0, "HybridConsensus: No rewards to claim.");

        rewards[msg.sender] = 0;
        payable(msg.sender).transfer(reward);
    }

    function adjustDifficulty(uint256 _newDifficulty) external onlyAdmin {
        currentDifficulty = _newDifficulty;
        emit DifficultyAdjusted(_newDifficulty);
    }

    function adjustStakeRequirement(uint256 _newStakeRequirement) external onlyAdmin {
        stakeRequirement = _newStakeRequirement;
        emit StakeRequirementAdjusted(_newStakeRequirement);
    }

    // Transfer admin role to a new address
    function transferAdminRole(address _newAdmin) external onlyAdmin {
        require(_newAdmin != address(0), "HybridConsensus: New admin address is the zero address.");
        admin = _newAdmin;
    }

    // Fallback function to accept Ether from claimReward refunds
    receive() external payable {}
}
