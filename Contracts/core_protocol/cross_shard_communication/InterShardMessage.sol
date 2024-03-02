// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title Inter Shard Message for MonsiBlockchain
 * @dev Facilitates the creation and handling of messages for cross-shard communication.
 */
contract InterShardMessage {
    struct Message {
        uint256 id;
        uint256 sourceShardId;
        uint256 targetShardId;
        address sender;
        address recipient;
        bytes payload;
        uint256 createdAt;
        bool executed;
    }

    // Incremental ID for tracking messages
    uint256 private nextMessageId = 1;

    // Mapping of message IDs to their corresponding Message structs
    mapping(uint256 => Message) public messages;

    // Event declarations for message lifecycle
    event MessageCreated(uint256 indexed messageId, uint256 sourceShardId, uint256 targetShardId, address indexed sender, address recipient);
    event MessageExecuted(uint256 indexed messageId, address indexed executor);

    /**
     * @dev Creates a new inter-shard message.
     * @param _sourceShardId ID of the shard where the message originates.
     * @param _targetShardId ID of the shard where the message is intended.
     * @param _recipient Address of the recipient in the target shard.
     * @param _payload Data or instructions contained in the message.
     */
    function createMessage(uint256 _sourceShardId, uint256 _targetShardId, address _recipient, bytes memory _payload) external {
        uint256 messageId = nextMessageId++;
        messages[messageId] = Message({
            id: messageId,
            sourceShardId: _sourceShardId,
            targetShardId: _targetShardId,
            sender: msg.sender,
            recipient: _recipient,
            payload: _payload,
            createdAt: block.timestamp,
            executed: false
        });

        emit MessageCreated(messageId, _sourceShardId, _targetShardId, msg.sender, _recipient);
    }

    /**
     * @dev Marks a message as executed. This function would typically be called by the cross-shard message handler
     * in the target shard to indicate that the message has been processed.
     * @param _messageId ID of the message to mark as executed.
     */
    function executeMessage(uint256 _messageId) external {
        Message storage message = messages[_messageId];
        require(!message.executed, "InterShardMessage: Message already executed");
        require(message.targetShardId == 0, "InterShardMessage: Invalid target shard ID"); // Placeholder validation
        
        message.executed = true;
        emit MessageExecuted(_messageId, msg.sender);
    }

    // Additional helper functions for querying and managing messages can be added here.
}
