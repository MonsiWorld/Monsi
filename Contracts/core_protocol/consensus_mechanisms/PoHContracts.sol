// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./MonsiOwnable.sol";

contract PoHContracts is MonsiOwnable {
    // Structure to represent an event in history
    struct HistoricalEvent {
        uint256 timestamp;
        bytes32 dataHash; // Hash of the data representing the event
        string description; // A brief description of the event
    }

    // Array to store historical events
    HistoricalEvent[] public history;

    // Event to log the addition of a new historical event
    event HistoricalEventAdded(uint256 indexed eventIndex, uint256 timestamp, bytes32 dataHash, string description);

    // Function to add a new event to the history
    function addHistoricalEvent(bytes32 _dataHash, string memory _description) public onlyOwner {
        uint256 eventIndex = history.length;
        history.push(HistoricalEvent({
            timestamp: block.timestamp,
            dataHash: _dataHash,
            description: _description
        }));

        emit HistoricalEventAdded(eventIndex, block.timestamp, _dataHash, _description);
    }

    // Function to retrieve a historical event by index
    function getHistoricalEvent(uint256 _index) public view returns (HistoricalEvent memory) {
        require(_index < history.length, "Invalid event index");
        return history[_index];
    }

    // Function to get the total number of historical events recorded
    function getTotalEvents() public view returns (uint256) {
        return history.length;
    }
}
