// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./AccessControl.sol";

/**
 * @title Validator Registry for MonsiBlockchain
 * @dev Manages the registration, update, and removal of validators in the MonsiBlockchain ecosystem.
 */
contract ValidatorRegistry is AccessControl {
    bytes32 public constant REGISTRAR_ROLE = keccak256("REGISTRAR_ROLE");

    struct Validator {
        address addr;
        string metadata; // Metadata could include off-chain information like IP addresses or node names.
        bool isActive;
    }

    // Mapping from validator address to validator data
    mapping(address => Validator) public validators;

    // Event declarations
    event ValidatorAdded(address indexed validator, string metadata);
    event ValidatorUpdated(address indexed validator, string newMetadata);
    event ValidatorRemoved(address indexed validator);
    event ValidatorStatusChanged(address indexed validator, bool isActive);

    constructor() {
        _grantRole(REGISTRAR_ROLE, msg.sender); // Grant the deployer the initial registrar role
    }

    /**
     * @dev Adds a new validator to the registry.
     * @param _validator The address of the validator to add.
     * @param _metadata Metadata associated with the validator.
     */
    function addValidator(address _validator, string memory _metadata) public onlyRole(REGISTRAR_ROLE) {
        require(_validator != address(0), "ValidatorRegistry: validator address cannot be the zero address");
        require(!validators[_validator].isActive, "ValidatorRegistry: validator already registered");

        validators[_validator] = Validator({
            addr: _validator,
            metadata: _metadata,
            isActive: true
        });

        emit ValidatorAdded(_validator, _metadata);
    }

    /**
     * @dev Updates the metadata for an existing validator.
     * @param _validator The address of the validator to update.
     * @param _newMetadata The new metadata for the validator.
     */
    function updateValidator(address _validator, string memory _newMetadata) public onlyRole(REGISTRAR_ROLE) {
        require(validators[_validator].isActive, "ValidatorRegistry: validator not found");

        validators[_validator].metadata = _newMetadata;

        emit ValidatorUpdated(_validator, _newMetadata);
    }

    /**
     * @dev Removes a validator from the registry.
     * @param _validator The address of the validator to remove.
     */
    function removeValidator(address _validator) public onlyRole(REGISTRAR_ROLE) {
        require(validators[_validator].isActive, "ValidatorRegistry: validator not found");

        validators[_validator].isActive = false;

        emit ValidatorRemoved(_validator);
    }

    /**
     * @dev Changes the active status of a validator.
     * @param _validator The address of the validator.
     * @param _isActive The new active status.
     */
    function setValidatorStatus(address _validator, bool _isActive) public onlyRole(REGISTRAR_ROLE) {
        require(validators[_validator].addr != address(0), "ValidatorRegistry: validator not found");

        validators[_validator].isActive = _isActive;

        emit ValidatorStatusChanged(_validator, _isActive);
    }

    /**
     * @dev Returns the validator data for a given address.
     * @param _validator The address of the validator.
     * @return The validator data.
     */
    function getValidator(address _validator) public view returns (Validator memory) {
        require(validators[_validator].isActive, "ValidatorRegistry: validator not found");
        return validators[_validator];
    }
}
