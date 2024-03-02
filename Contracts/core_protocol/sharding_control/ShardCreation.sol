// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ShardingManager.sol";

/**
 * @title Shard Creation for MonsiBlockchain
 * @dev Handles the creation and initial setup of shards.
 */
contract ShardCreation {
    ShardingManager public shardingManager;

    event ShardInitialized(uint256 indexed shardId, string description, address[] initialValidators);

    constructor(address _shardingManagerAddress) {
        require(_shardingManagerAddress != address(0), "ShardCreation: Invalid ShardingManager address");
        shardingManager = ShardingManager(_shardingManagerAddress);
    }

    /**
     * @dev Creates a new shard with initial validators.
     * @param description The description of the new shard.
     * @param initialValidators An array of addresses to be assigned as validators to the new shard.
     */
    function createShard(string memory description, address[] memory initialValidators) public {
        // Ensure the caller has the right to create shards. In a real implementation, this could
        // be restricted to certain roles or addresses with specific permissions.
        
        uint256 shardId = shardingManager.shardCount();
        shardingManager.createShard(description);

        // Assign initial validators to the shard
        for(uint256 i = 0; i < initialValidators.length; i++) {
            shardingManager.assignValidator(shardId, initialValidators[i]);
        }

        emit ShardInitialized(shardId, description, initialValidators);
    }

    // Additional helper functions for shard creation and management can be added here.
}
