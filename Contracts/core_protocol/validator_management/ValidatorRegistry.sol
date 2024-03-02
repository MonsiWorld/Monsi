// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./MonsiOwnable.sol";

contract ValidatorRegistry is MonsiOwnable {
    struct Validator {
        address validatorAddress;
        string name;
        string metadata; // Additional information, e.g., validator's website or contact info
        bool isActive;
    }

    // Mapping from validator addresses to their details
    mapping(address => Validator) public validators;

    // Event declarations
    event ValidatorRegistered(address indexed validatorAddress, string name, string metadata);
    event ValidatorUpdated(address indexed validatorAddress, string name, string metadata);
    event ValidatorStatusChanged(address indexed validatorAddress, bool isActive);

    // Register a new validator
    function registerValidator(address _validatorAddress, string memory _name, string memory _metadata) public onlyOwner {
        require(_validatorAddress != address(0), "Invalid address");
        require(!validators[_validatorAddress].isActive, "Validator already registered");

        validators[_validatorAddress] = Validator({
            validatorAddress: _validatorAddress,
            name: _name,
            metadata: _metadata,
            isActive: true
        });

        emit ValidatorRegistered(_validatorAddress, _name, _metadata);
    }

    // Update validator information
    function updateValidator(address _validatorAddress, string memory _name, string memory _metadata) public onlyOwner {
        require(_validatorAddress != address(0), "Invalid address");
        require(validators[_validatorAddress].isActive, "Validator not found");

        Validator storage validator = validators[_validatorAddress];
        validator.name = _name;
        validator.metadata = _metadata;

        emit ValidatorUpdated(_validatorAddress, _name, _metadata);
    }

    // Change validator's active status
    function setValidatorStatus(address _validatorAddress, bool _isActive) public onlyOwner {
        require(_validatorAddress != address(0), "Invalid address");
        require(validators[_validatorAddress].isActive != _isActive, "Status already set as desired");

        validators[_validatorAddress].isActive = _isActive;

        emit ValidatorStatusChanged(_validatorAddress, _isActive);
    }

    // Retrieve validator details
    function getValidator(address _validatorAddress) public view returns (Validator memory) {
        require(_validatorAddress != address(0), "Invalid address");
        require(validators[_validatorAddress].isActive, "Validator not found");

        return validators[_validatorAddress];
    }
}
