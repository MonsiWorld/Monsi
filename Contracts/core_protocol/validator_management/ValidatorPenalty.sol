// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./AccessControl.sol";
import "./StakingRewards.sol";

/**
 * @title Validator Penalty for MonsiBlockchain
 * @dev Manages penalties for validators, including stake slashing for non-compliance or malicious actions.
 */
contract ValidatorPenalty is AccessControl {
    bytes32 public constant SLASHER_ROLE = keccak256("SLASHER_ROLE");
    StakingRewards public stakingRewardsContract;

    // Mapping of validator addresses to penalty amounts
    mapping(address => uint256) public penalties;

    // Event declarations for logging penalties and slashes
    event PenaltyImposed(address indexed validator, uint256 amount);
    event PenaltyCleared(address indexed validator);
    event RewardsSlashed(address indexed validator, uint256 slashAmount);

    constructor(address _stakingRewardsAddress) {
        require(_stakingRewardsAddress != address(0), "ValidatorPenalty: Invalid StakingRewards address");
        stakingRewardsContract = StakingRewards(_stakingRewardsAddress);
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender); // Grant deployer the admin role for managing the contract
    }

    /**
     * @dev Imposes a penalty on a validator. Only accounts with the SLASHER_ROLE can call this function.
     * @param validator The address of the validator being penalized.
     * @param amount The amount of the penalty.
     */
    function imposePenalty(address validator, uint256 amount) external onlyRole(SLASHER_ROLE) {
        require(validator != address(0), "ValidatorPenalty: Invalid validator address");
        penalties[validator] += amount;
        emit PenaltyImposed(validator, amount);
    }

    /**
     * @dev Clears the penalty for a validator, typically after it's been paid or served.
     * @param validator The address of the validator whose penalty is being cleared.
     */
    function clearPenalty(address validator) external onlyRole(DEFAULT_ADMIN_ROLE) {
        require(penalties[validator] > 0, "ValidatorPenalty: No penalties to clear");
        penalties[validator] = 0;
        emit PenaltyCleared(validator);
    }

    /**
     * @dev Slashes rewards of a validator as a form of penalty. This reduces the validator's accumulated rewards.
     * @param validator The address of the validator whose rewards are being slashed.
     */
    function slashRewards(address validator) external onlyRole(SLASHER_ROLE) {
        uint256 penaltyAmount = penalties[validator];
        require(penaltyAmount > 0, "ValidatorPenalty: No penalty to enforce");
        require(stakingRewardsContract.rewards(validator) >= penaltyAmount, "ValidatorPenalty: Insufficient rewards to slash");

        // Assuming stakingRewardsContract has a function to deduct rewards
        stakingRewardsContract.deductRewards(validator, penaltyAmount);
        penalties[validator] = 0; // Clear the penalty after slashing

        emit RewardsSlashed(validator, penaltyAmount);
    }

    // Additional helper functions for managing and querying penalties can be added here.
}
