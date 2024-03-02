// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title Shard Registry for MonsiBlockchain
 * @dev Manages the registration and tracking of shards and their associated information.
 */
contract ShardRegistry {
    struct ShardInfo {
        uint256 id;
        string description;
        address[] validators;
        bool isActive;
    }

    // Mapping from shard ID to ShardInfo
    mapping(uint256 => ShardInfo) public shards;
    uint256 public nextShardId;

    // Event declarations
    event ShardRegistered(uint256 indexed shardId, string description);
    event ShardUpdated(uint256 indexed shardId, string description);
    event ValidatorAdded(uint256 indexed shardId, address validator);
    event ValidatorRemoved(uint256 indexed shardId, address validator);
    event ShardStatusChanged(uint256 indexed shardId, bool isActive);

    /**
     * @dev Registers a new shard with the given description and initial validators.
     * @param description The description of the shard.
     * @param validators An array of addresses that will serve as the initial validators for the shard.
     */
    function registerShard(string memory description, address[] memory validators) external {
        uint256 shardId = nextShardId++;
        shards[shardId] = ShardInfo({
            id: shardId,
            description: description,
            validators: validators,
            isActive: true
        });

        emit ShardRegistered(shardId, description);
    }

    /**
     * @dev Updates the description of a specific shard.
     * @param shardId The ID of the shard to update.
     * @param newDescription The new description for the shard.
     */
    function updateShardDescription(uint256 shardId, string memory newDescription) external {
        require(shardId < nextShardId, "ShardRegistry: Invalid shard ID");
        shards[shardId].description = newDescription;

        emit ShardUpdated(shardId, newDescription);
    }

    /**
     * @dev Adds a validator to a shard.
     * @param shardId The ID of the shard.
     * @param validator The address of the validator to add.
     */
    function addValidatorToShard(uint256 shardId, address validator) external {
        require(shardId < nextShardId, "ShardRegistry: Invalid shard ID");
        shards[shardId].validators.push(validator);

        emit ValidatorAdded(shardId, validator);
    }

    /**
     * @dev Removes a validator from a shard.
     * @param shardId The ID of the shard.
     * @param validator The address of the validator to remove.
     */
    function removeValidatorFromShard(uint256 shardId, address validator) external {
        require(shardId < nextShardId, "ShardRegistry: Invalid shard ID");

        // Find and remove the validator
        address[] storage validators = shards[shardId].validators;
        for (uint256 i = 0; i < validators.length; i++) {
            if (validators[i] == validator) {
                validators[i] = validators[validators.length - 1];
                validators.pop();
                emit ValidatorRemoved(shardId, validator);
                return;
            }
        }
    }

    /**
     * @dev Changes the active status of a shard.
     * @param shardId The ID of the shard.
     * @param isActive The new active status.
     */
    function setShardStatus(uint256 shardId, bool isActive) external {
        require(shardId < nextShardId, "ShardRegistry: Invalid shard ID");
        shards[shardId].isActive = isActive;

        emit ShardStatusChanged(shardId, isActive);
    }

    // Additional functions for querying shard and validator information can be added here.
}
