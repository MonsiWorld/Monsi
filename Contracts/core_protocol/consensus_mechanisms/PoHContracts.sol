// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title Proof of History (PoH) Contracts
 * @dev Simulates the Proof of History concept by recording actions with timestamps on Ethereum.
 */
contract PoHContracts {
    struct HistoricalEvent {
        bytes32 dataHash; // Hash representing the event data
        uint256 timestamp; // Block timestamp when the event was recorded
    }

    HistoricalEvent[] public history;

    event EventRecorded(bytes32 indexed dataHash, uint256 indexed timestamp);

    /**
     * @dev Records an event in history with the current block timestamp.
     * @param dataHash Hash of the data representing the event.
     */
    function recordEvent(bytes32 dataHash) external {
        history.push(HistoricalEvent(dataHash, block.timestamp));
        emit EventRecorded(dataHash, block.timestamp);
    }

    /**
     * @dev Verifies if an event with the given hash was recorded at a specific timestamp.
     * @param dataHash Hash of the data representing the event.
     * @param timestamp Timestamp when the event is claimed to have occurred.
     * @return bool True if the event exists with the exact timestamp, false otherwise.
     */
    function verifyEvent(bytes32 dataHash, uint256 timestamp) external view returns (bool) {
        for (uint256 i = 0; i < history.length; i++) {
            if (history[i].dataHash == dataHash && history[i].timestamp == timestamp) {
                return true;
            }
        }
        return false;
    }

    /**
     * @dev Returns the total number of recorded events in history.
     * @return uint256 Total number of events.
     */
    function getTotalEvents() external view returns (uint256) {
        return history.length;
    }
}
