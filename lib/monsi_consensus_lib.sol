// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library MonsiConsensusLib {
    struct ConsensusParameters {
        uint blockTime; // Time in seconds between blocks
        uint validatorSetSize; // Number of validators in the consensus mechanism
        // Additional consensus parameters can be added here
    }

    // Initializes the consensus parameters
    function init(ConsensusParameters storage self, uint _blockTime, uint _validatorSetSize) internal {
        self.blockTime = _blockTime;
        self.validatorSetSize = _validatorSetSize;
    }

    // Updates the consensus parameters
    function update(ConsensusParameters storage self, uint _blockTime, uint _validatorSetSize) internal {
        self.blockTime = _blockTime;
        self.validatorSetSize = _validatorSetSize;
        // Emit an event or log the update operation here if needed
    }
}
