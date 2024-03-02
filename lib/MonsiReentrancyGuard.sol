// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @dev Custom non-reentrant guard for MonsiBlockchain.
 */
abstract contract MonsiReentrancyGuard {
    // Using uint256 for more straightforward comparison and manipulation
    uint256 private _status;

    // Constants representing the lock status
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    constructor() {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     */
    modifier nonReentrant() {
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
        _status = _ENTERED;
        _;
        _status = _NOT_ENTERED;
    }
}
