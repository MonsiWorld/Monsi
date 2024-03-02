// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title Access Control for MonsiBlockchain
 * @dev Manages roles and permissions within the MonsiBlockchain ecosystem.
 */
contract AccessControl {
    // Mapping from role to addresses to boolean indicating whether the address has the role
    mapping(bytes32 => mapping(address => bool)) private roles;

    // Events for adding and removing roles
    event RoleGranted(bytes32 indexed role, address indexed account);
    event RoleRevoked(bytes32 indexed role, address indexed account);

    /**
     * @dev Modifier to make a function callable only by accounts with a certain role.
     */
    modifier onlyRole(bytes32 role) {
        require(hasRole(role, msg.sender), "AccessControl: caller does not have the required role");
        _;
    }

    /**
     * @dev Grant a role to an account.
     * @param role The role identifier.
     * @param account The account to receive the role.
     */
    function grantRole(bytes32 role, address account) public onlyRole(role) {
        roles[role][account] = true;
        emit RoleGranted(role, account);
    }

    /**
     * @dev Revoke a role from an account.
     * @param role The role identifier.
     * @param account The account to lose the role.
     */
    function revokeRole(bytes32 role, address account) public onlyRole(role) {
        roles[role][account] = false;
        emit RoleRevoked(role, account);
    }

    /**
     * @dev Check if an account has a certain role.
     * @param role The role identifier.
     * @param account The account to check.
     * @return hasRole Whether the account has the role.
     */
    function hasRole(bytes32 role, address account) public view returns (bool) {
        return roles[role][account];
    }
}
