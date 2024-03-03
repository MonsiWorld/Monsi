// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title ProofOfHistory
 * @dev Simulates Proof of History (PoH) by using Ethereum block timestamps to record and verify the timing of transactions.
 */
contract ProofOfHistory {
    // Event to log each transaction with its timestamp
    event TransactionRecorded(address indexed sender, bytes32 indexed transactionHash, uint256 timestamp);

    // Structure to hold transaction details
    struct TransactionDetail {
        address sender;
        bytes32 transactionHash;
        uint256 timestamp;
    }

    // Array to store transactions
    TransactionDetail[] public transactions;

    /**
     * @dev Records a transaction with the current block timestamp.
     * @param transactionHash The hash of the transaction being recorded.
     */
    function recordTransaction(bytes32 transactionHash) external {
        transactions.push(TransactionDetail({
            sender: msg.sender,
            transactionHash: transactionHash,
            timestamp: block.timestamp
        }));

        emit TransactionRecorded(msg.sender, transactionHash, block.timestamp);
    }

    /**
     * @dev Verifies if a transaction with the given hash was recorded.
     * @param transactionHash The hash of the transaction to verify.
     * @return exists Boolean indicating if the transaction exists.
     * @return index The index of the transaction in the array if it exists.
     */
    function verifyTransaction(bytes32 transactionHash) external view returns (bool exists, uint256 index) {
        for (uint256 i = 0; i < transactions.length; i++) {
            if (transactions[i].transactionHash == transactionHash) {
                return (true, i);
            }
        }
        return (false, 0);
    }

    /**
     * @dev Returns the total number of recorded transactions.
     * @return The total number of transactions.
     */
    function getTotalTransactions() external view returns (uint256) {
        return transactions.length;
    }
}
