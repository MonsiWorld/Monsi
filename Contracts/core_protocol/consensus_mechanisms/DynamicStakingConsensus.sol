// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title DynamicStakingConsensus
 * @dev Implements a dynamic staking consensus mechanism for the MONSI blockchain.
 */
contract DynamicStakingConsensus {
    mapping(address => uint256) public stakes;
    uint256 public totalStaked;
    uint256 public minimumStake;
    address public admin;

    event StakeDeposited(address indexed staker, uint256 amount);
    event StakeWithdrawn(address indexed staker, uint256 amount);
    event MinimumStakeUpdated(uint256 newMinimumStake);

    constructor(uint256 _minimumStake) {
        require(_minimumStake > 0, "Minimum stake must be greater than 0");
        admin = msg.sender;
        minimumStake = _minimumStake;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    /**
     * @dev Allows participants to deposit tokens as stake.
     * @param amount The amount of tokens to stake.
     */
    function depositStake(uint256 amount) external {
        require(amount >= minimumStake, "Deposit amount is less than the minimum stake");
        
        // Simulate the transfer of tokens to this contract for staking
        stakes[msg.sender] += amount;
        totalStaked += amount;

        emit StakeDeposited(msg.sender, amount);
    }

    /**
     * @dev Allows participants to withdraw their staked tokens.
     * @param amount The amount of tokens to withdraw.
     */
    function withdrawStake(uint256 amount) external {
        require(amount <= stakes[msg.sender], "Withdrawal amount exceeds staked amount");
        
        stakes[msg.sender] -= amount;
        totalStaked -= amount;

        // Simulate the transfer of tokens back to the staker from this contract
        emit StakeWithdrawn(msg.sender, amount);
    }

    /**
     * @dev Updates the minimum stake required for participation.
     * @param _minimumStake The new minimum stake amount.
     */
    function updateMinimumStake(uint256 _minimumStake) external onlyAdmin {
        require(_minimumStake > 0, "Minimum stake must be greater than 0");
        minimumStake = _minimumStake;
        emit MinimumStakeUpdated(_minimumStake);
    }

    // Additional functions for dynamic adjustment of staking parameters,
    // rewards distribution, and consensus mechanism governance could be added here
}
