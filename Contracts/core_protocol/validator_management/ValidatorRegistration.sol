// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ValidatorRegistry.sol";
import "./MonsiOwnable.sol";

contract ValidatorRegistration is MonsiOwnable {
    ValidatorRegistry private registry;
    uint256 public registrationFee;

    event ValidatorApplied(address indexed validatorAddress, uint256 feePaid);
    event RegistrationFeeUpdated(uint256 newFee);

    constructor(address _registryAddress, uint256 _registrationFee) {
        require(_registryAddress != address(0), "Invalid registry address");
        registry = ValidatorRegistry(_registryAddress);
        registrationFee = _registrationFee;
    }

    // Allows validators to register by paying a fee
    function applyForValidation(string memory _name, string memory _metadata) public payable {
        require(msg.value == registrationFee, "Incorrect registration fee");
        
        // Transfer the registration fee to the registry owner or a designated wallet
        // This could also be used to stake tokens for PoS or DPoS consensus mechanisms
        payable(owner()).transfer(msg.value);

        // Call the registry to register the validator
        // Note: This requires the ValidatorRegistry contract to have a function that allows this contract to register validators
        registry.registerValidator(msg.sender, _name, _metadata);

        emit ValidatorApplied(msg.sender, msg.value);
    }

    // Allows the owner to update the registration fee
    function updateRegistrationFee(uint256 _newFee) public onlyOwner {
        registrationFee = _newFee;
        emit RegistrationFeeUpdated(_newFee);
    }

    // Function to withdraw the collected registration fees
    // Only the owner can call this function
    function withdrawFees(address payable _to) public onlyOwner {
        require(_to != address(0), "Invalid address");
        _to.transfer(address(this).balance);
    }
}
