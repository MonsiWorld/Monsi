// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title Identity Manager for MonsiBlockchain
 * @dev Manages user identities, including registration, updates, and retrieval. 
 * Provides a basis for identity verification across the blockchain ecosystem.
 */
contract IdentityManager {
    struct Identity {
        string name;
        string email; // Consider encrypting sensitive information
        bytes32 identityHash; // A hash representing the identity for privacy
        bool isActive;
    }

    // Mapping from user addresses to their identities
    mapping(address => Identity) private identities;

    // Event declarations
    event IdentityRegistered(address indexed userAddress, bytes32 identityHash);
    event IdentityUpdated(address indexed userAddress, bytes32 newIdentityHash);
    event IdentityStatusChanged(address indexed userAddress, bool isActive);

    /**
     * @dev Registers a new identity. Emits an IdentityRegistered event.
     * @param _name User's name.
     * @param _email User's email.
     * @param _identityHash A hash representing the user's identity.
     */
    function registerIdentity(string memory _name, string memory _email, bytes32 _identityHash) public {
        require(!identities[msg.sender].isActive, "Identity already registered");

        identities[msg.sender] = Identity({
            name: _name,
            email: _email,
            identityHash: _identityHash,
            isActive: true
        });

        emit IdentityRegistered(msg.sender, _identityHash);
    }

    /**
     * @dev Updates an existing identity. Emits an IdentityUpdated event.
     * @param _newName New user name.
     * @param _newEmail New user email.
     * @param _newIdentityHash New hash representing the user's identity.
     */
    function updateIdentity(string memory _newName, string memory _newEmail, bytes32 _newIdentityHash) public {
        require(identities[msg.sender].isActive, "Identity not found");

        identities[msg.sender].name = _newName;
        identities[msg.sender].email = _newEmail;
        identities[msg.sender].identityHash = _newIdentityHash;

        emit IdentityUpdated(msg.sender, _newIdentityHash);
    }

    /**
     * @dev Changes the active status of an identity. Emits an IdentityStatusChanged event.
     * @param _userAddress The address of the user whose identity status is to be changed.
     * @param _isActive New active status of the identity.
     */
    function setIdentityStatus(address _userAddress, bool _isActive) public {
        require(_userAddress != address(0), "Invalid address");
        require(identities[_userAddress].isActive != _isActive, "Identity status already set");

        identities[_userAddress].isActive = _isActive;

        emit IdentityStatusChanged(_userAddress, _isActive);
    }

    /**
     * @dev Retrieves an identity.
     * @param _userAddress Address of the user whose identity is being retrieved.
     * @return Identity The identity of the requested user.
     */
    function getIdentity(address _userAddress) public view returns (Identity memory) {
        require(_userAddress != address(0), "Invalid address");
        require(identities[_userAddress].isActive, "Identity not found");

        return identities[_userAddress];
    }
}
