// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// A simplified DPoS contract for educational purposes
contract DPoSContracts {
    // Define a struct for validator information
    struct Validator {
        address validatorAddress;
        uint256 stake;
        uint256 voteCount;
        bool isActive;
    }

    // State variables
    address public owner;
    Validator[] public validators;
    mapping(address => uint256) public validatorIndexes;
    mapping(address => address) public votes; // voterAddress => validatorAddress

    // Events
    event ValidatorRegistered(address indexed validatorAddress);
    event ValidatorVoted(address indexed voter, address indexed validatorAddress, uint256 voteCount);
    event ValidatorUnregistered(address indexed validatorAddress);

    // Modifiers
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can perform this action.");
        _;
    }

    modifier onlyValidator() {
        require(validatorIndexes[msg.sender] != 0, "Only registered validators can perform this action.");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    // Register a new validator
    function registerValidator() external {
        require(validatorIndexes[msg.sender] == 0, "Validator is already registered.");

        validators.push(Validator({
            validatorAddress: msg.sender,
            stake: 0, // Initial stake is set to 0
            voteCount: 0,
            isActive: true
        }));

        // The index is the position in the array, adjusted for 1-based indexing
        validatorIndexes[msg.sender] = validators.length;
        emit ValidatorRegistered(msg.sender);
    }

    // Unregister a validator
    function unregisterValidator() external onlyValidator {
        uint256 index = validatorIndexes[msg.sender] - 1;
        validators[index].isActive = false;
        emit ValidatorUnregistered(msg.sender);
    }

    // Vote for a validator
    function voteForValidator(address validatorAddress) external {
        require(validatorIndexes[validatorAddress] != 0, "Validator does not exist.");
        
        // Update the voter's choice
        votes[msg.sender] = validatorAddress;

        // Increment the validator's vote count
        uint256 index = validatorIndexes[validatorAddress] - 1;
        validators[index].voteCount += 1;
        emit ValidatorVoted(msg.sender, validatorAddress, validators[index].voteCount);
    }

    // List all validators
    function listValidators() external view returns (Validator[] memory) {
        return validators;
    }
}
