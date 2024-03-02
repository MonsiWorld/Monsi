// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./MonsiOwnable.sol";

contract DPoAContracts is MonsiOwnable {
    // Event declarations
    event ValidatorAdded(address indexed validator);
    event ValidatorRemoved(address indexed validator);

    // Mapping to keep track of validators
    mapping(address => bool) private validators;

    // Modifier to restrict function calls to only validators
    modifier onlyValidator() {
        require(isValidator(msg.sender), "Caller is not a validator");
        _;
    }

    // Function to add a new validator
    function addValidator(address _validator) public onlyOwner {
        require(_validator != address(0), "Invalid validator address");
        require(!validators[_validator], "Validator already added");
        validators[_validator] = true;
        emit ValidatorAdded(_validator);
    }

    // Function to remove an existing validator
    function removeValidator(address _validator) public onlyOwner {
        require(validators[_validator], "Not a validator");
        validators[_validator] = false;
        emit ValidatorRemoved(_validator);
    }

    // Function to check if an address is a validator
    function isValidator(address _address) public view returns (bool) {
        return validators[_address];
    }

    // Example function that could represent a validator-specific action
    function validateTransaction(bytes32 _transactionHash) public onlyValidator returns (bool) {
        // In a real DPoA implementation, this function would contain logic for validators
        // to validate a transaction. This example simply returns true to simulate success.
        return true;
    }

    // Constructor to initialize the contract with the owner as the first validator
    constructor() {
        addValidator(msg.sender);
    }
}
