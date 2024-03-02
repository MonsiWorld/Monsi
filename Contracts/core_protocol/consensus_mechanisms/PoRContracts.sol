// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./MonsiOwnable.sol";

contract PoRContracts is MonsiOwnable {
    // Structure to represent a participant
    struct Participant {
        address participantAddress;
        uint256 reputationScore; // The reputation score of the participant
        string name; // Optional: Name of the participant
    }

    // Mapping from participant address to their details
    mapping(address => Participant) public participants;

    // Event to log participant addition and reputation updates
    event ParticipantAdded(address indexed participantAddress, uint256 reputationScore, string name);
    event ReputationUpdated(address indexed participantAddress, uint256 newReputationScore);

    // Function to add a new participant
    function addParticipant(address _participantAddress, uint256 _reputationScore, string memory _name) public onlyOwner {
        require(_participantAddress != address(0), "Invalid address");
        require(participants[_participantAddress].participantAddress == address(0), "Participant already exists");

        participants[_participantAddress] = Participant({
            participantAddress: _participantAddress,
            reputationScore: _reputationScore,
            name: _name
        });

        emit ParticipantAdded(_participantAddress, _reputationScore, _name);
    }

    // Function to update a participant's reputation score
    function updateReputation(address _participantAddress, uint256 _newReputationScore) public onlyOwner {
        require(participants[_participantAddress].participantAddress != address(0), "Participant does not exist");
        participants[_participantAddress].reputationScore = _newReputationScore;

        emit ReputationUpdated(_participantAddress, _newReputationScore);
    }

    // Function to get a participant's details by address
    function getParticipant(address _participantAddress) public view returns (Participant memory) {
        require(participants[_participantAddress].participantAddress != address(0), "Participant does not exist");
        return participants[_participantAddress];
    }
}
