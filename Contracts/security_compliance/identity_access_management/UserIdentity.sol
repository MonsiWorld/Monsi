// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title User Identity Contract for MonsiBlockchain
 * @dev Manages individual user identity data, providing functions for users to set and update their own information.
 */
contract UserIdentity {
    // Owner of the identity; this address is the only one that can update the identity info.
    address public owner;

    // Struct to hold identity information.
    struct IdentityInfo {
        string name;
        string email; // Consider implementing encryption or privacy-preserving techniques for sensitive data.
        bytes32 dataHash; // A hash of additional identity data, possibly stored off-chain.
    }

    IdentityInfo public identityInfo;

    // Modifier to restrict function calls to the owner of the identity.
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function.");
        _;
    }

    // Event declarations for logging changes.
    event IdentityInfoUpdated(string name, string email, bytes32 dataHash);

    // Constructor to set the initial owner of the identity.
    constructor() {
        owner = msg.sender; // The deployer of the contract is the initial owner.
    }

    /**
     * @dev Allows the owner to update their identity information.
     * @param _name The new name of the user.
     * @param _email The new email of the user.
     * @param _dataHash A new hash of the user's identity data.
     */
    function updateIdentityInfo(string memory _name, string memory _email, bytes32 _dataHash) public onlyOwner {
        identityInfo.name = _name;
        identityInfo.email = _email;
        identityInfo.dataHash = _dataHash;

        emit IdentityInfoUpdated(_name, _email, _dataHash);
    }

    /**
     * @dev Transfers ownership of the identity to a new address.
     * @param newOwner The address of the new owner.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "New owner address cannot be the zero address.");
        owner = newOwner;
    }

    /**
     * @dev Retrieves the current identity information.
     * @return The current IdentityInfo struct.
     */
    function getIdentityInfo() public view returns (IdentityInfo memory) {
        return identityInfo;
    }
}
