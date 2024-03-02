// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * OracleInterface is assumed to be an external contract interface
 * that MonsiBlockchain's AIAdaptiveConsensus contract will call to fetch
 * optimized consensus parameters. This interface must be implemented
 * by the actual Oracle contract.
 */
interface OracleInterface {
    function getOptimalParameters() external returns (uint256, uint256);
}

/**
 * @title AIAdaptiveConsensus
 * @dev Implements an AI-driven adaptive consensus mechanism for the MonsiBlockchain.
 * This contract interacts with an external Oracle to dynamically adjust consensus parameters,
 * optimizing for network efficiency and security.
 */
contract AIAdaptiveConsensus {
    uint256 public blockTime;
    uint256 public difficulty;
    address private admin;
    OracleInterface public oracle;

    event ConsensusParameterChanged(string parameter, uint256 value);

    modifier onlyAdmin() {
        require(msg.sender == admin, "AIAdaptiveConsensus: Only the admin can perform this action.");
        _;
    }

    constructor(uint256 _initialBlockTime, uint256 _initialDifficulty, address _oracleAddress) {
        require(_oracleAddress != address(0), "AIAdaptiveConsensus: Oracle address cannot be the zero address.");
        admin = msg.sender;
        blockTime = _initialBlockTime;
        difficulty = _initialDifficulty;
        oracle = OracleInterface(_oracleAddress);
    }

    function adjustBlockTime(uint256 _newBlockTime) public onlyAdmin {
        require(_newBlockTime > 0, "AIAdaptiveConsensus: Block time must be greater than 0.");
        blockTime = _newBlockTime;
        emit ConsensusParameterChanged("blockTime", _newBlockTime);
    }

    function adjustDifficulty(uint256 _newDifficulty) public onlyAdmin {
        require(_newDifficulty > 0, "AIAdaptiveConsensus: Difficulty must be greater than 0.");
        difficulty = _newDifficulty;
        emit ConsensusParameterChanged("difficulty", _newDifficulty);
    }

    /**
     * @dev Fetches and applies AI-driven parameter adjustments from an Oracle.
     */
    function aiAdjustParameters() external onlyAdmin {
        (uint256 _newBlockTime, uint256 _newDifficulty) = oracle.getOptimalParameters();

        if (_newBlockTime != blockTime && _newBlockTime > 0) {
            adjustBlockTime(_newBlockTime);
        }
        if (_newDifficulty != difficulty && _newDifficulty > 0) {
            adjustDifficulty(_newDifficulty);
        }
    }

    /**
     * @dev Allows changing the Oracle address.
     * @param _newOracleAddress The address of the new Oracle.
     */
    function changeOracleAddress(address _newOracleAddress) external onlyAdmin {
        require(_newOracleAddress != address(0), "AIAdaptiveConsensus: Oracle address cannot be the zero address.");
        oracle = OracleInterface(_newOracleAddress);
    }
}
