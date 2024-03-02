// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./AccessControl.sol";

/**
 * @title Sharding Manager for MonsiBlockchain
 * @dev Manages the sharding process to enhance scalability and performance.
 */
contract ShardingManager is AccessControl {
    bytes32 public constant SHARD_MANAGER_ROLE = keccak256("SHARD_MANAGER_ROLE");

    struct Shard {
        uint256 id;
        string description;
        address[] validators; // Addresses of validators assigned to the shard
    }

    // Mapping from shard ID to Shard struct
    mapping(uint256 => Shard) public shards;
    uint256 public shardCount;

    // Event declarations
    event ShardCreated(uint256 indexed shardId, string description);
    event ValidatorAssigned(uint256 indexed shardId, address validator);
    event ValidatorRemoved(uint256 indexed shardId, address validator);

    constructor() {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender); // Assign admin role to contract deployer
    }

    /**
     * @dev Creates a new shard with a given description.
     * @param description The description of the shard.
     */
    function createShard(string memory description) public onlyRole(SHARD_MANAGER_ROLE) {
        uint256 shardId = shardCount++;
        shards[shardId] = Shard({
            id: shardId,
            description: description,
            validators: new address[](0)
        });

        emit ShardCreated(shardId, description);
    }

    /**
     * @dev Assigns a validator to a shard.
     * @param shardId The ID of the shard.
     * @param validator The address of the validator to assign.
     */
    function assignValidator(uint256 shardId, address validator) public onlyRole(SHARD_MANAGER_ROLE) {
        require(shardId < shardCount, "ShardingManager: Invalid shard ID");
        require(validator != address(0), "ShardingManager: Invalid validator address");

        shards[shardId].validators.push(validator);

        emit ValidatorAssigned(shardId, validator);
    }

    /**
     * @dev Removes a validator from a shard.
     * @param shardId The ID of the shard.
     * @param validator The address of the validator to remove.
     */
    function removeValidator(uint256 shardId, address validator) public onlyRole(SHARD_MANAGER_ROLE) {
        require(shardId < shardCount, "ShardingManager: Invalid shard ID");

        // Find and remove the validator from the shard
        for (uint i = 0; i < shards[shardId].validators.length; i++) {
            if (shards[shardId].validators[i] == validator) {
                shards[shardId].validators[i] = shards[shardId].validators[shards[shardId].validators.length - 1];
                shards[shardId].validators.pop();
                emit ValidatorRemoved(shardId, validator);
                return;
            }
        }

        revert("ShardingManager: Validator not found in shard");
    }

    // Additional functions for shard management and querying can be added here.
}
