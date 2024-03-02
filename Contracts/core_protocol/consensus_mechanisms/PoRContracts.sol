// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title Proof of Reputation (PoR) Contracts
 * @dev A simple PoR mechanism for Ethereum smart contracts, tracking reputation and incentivizing good behavior.
 */
contract PoRContracts {
    struct Participant {
        uint256 reputation;
        bool isRegistered;
    }

    address public admin;
    mapping(address => Participant) public participants;

    event ParticipantRegistered(address indexed participant);
    event ReputationUpdated(address indexed participant, uint256 newReputation);
    event RewardIssued(address indexed participant, uint256 amount);

    modifier onlyAdmin() {
        require(msg.sender == admin, "PoRContracts: Only admin can perform this action.");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    /**
     * @dev Registers a new participant in the PoR system.
     * @param participant Address of the participant to register.
     */
    function registerParticipant(address participant) external onlyAdmin {
        require(!participants[participant].isRegistered, "PoRContracts: Participant already registered.");
        participants[participant] = Participant(0, true);
        emit ParticipantRegistered(participant);
    }

    /**
     * @dev Updates the reputation of a participant.
     * @param participant Address of the participant.
     * @param reputationChange Amount to adjust the participant's reputation by. Can be positive or negative.
     */
    function updateReputation(address participant, int256 reputationChange) external onlyAdmin {
        require(participants[participant].isRegistered, "PoRContracts: Participant not registered.");
        if (reputationChange < 0 && uint256(-reputationChange) > participants[participant].reputation) {
            participants[participant].reputation = 0;
        } else {
            participants[participant].reputation += uint256(reputationChange);
        }
        emit ReputationUpdated(participant, participants[participant].reputation);
    }

    /**
     * @dev Issues a reward to a participant based on their reputation.
     * @param participant Address of the participant to reward.
     */
    function issueReward(address participant) external onlyAdmin {
        require(participants[participant].isRegistered, "PoRContracts: Participant not registered.");
        uint256 reward = calculateReward(participants[participant].reputation);
        // Placeholder for actual reward logic, e.g., transferring tokens
        emit RewardIssued(participant, reward);
    }

    /**
     * @dev Calculates the reward for a participant based on their reputation.
     * This version introduces a diminishing returns model to balance the rewards system.
     * @param reputation The reputation of the participant.
     * @return The calculated reward amount.
     */
    function calculateReward(uint256 reputation) public pure returns (uint256) {
        // Establishing base reward and diminishing returns threshold
        uint256 baseReward = 1 ether; // Base reward for each reputation point
        uint256 diminishingReturnsThreshold = 10; // Threshold at which rewards start to diminish
        uint256 maxReward = 20 ether; // Maximum reward cap

        if (reputation <= diminishingReturnsThreshold) {
            // For reputation up to the threshold, reward linearly
            return reputation * baseReward;
        } else {
            // Apply diminishing returns formula for reputation above the threshold
            uint256 additionalReputation = reputation - diminishingReturnsThreshold;
            // Example diminishing returns calculation (simplified)
            uint256 additionalReward = (diminishingReturnsThreshold * baseReward) / 2;
            additionalReward = (additionalReputation > diminishingReturnsThreshold) ? additionalReward : additionalReputation * baseReward / 2;

            uint256 totalReward = diminishingReturnsThreshold * baseReward + additionalReward;
            // Ensure the total reward does not exceed the maximum cap
            return (totalReward > maxReward) ? maxReward : totalReward;
        }
    }
}
