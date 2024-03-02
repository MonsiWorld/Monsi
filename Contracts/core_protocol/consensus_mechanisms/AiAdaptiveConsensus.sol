// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Assume ConsensusLib and AILib are defined in the same way as previously shown

contract Ownable {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() {
        _owner = msg.sender;
        emit OwnershipTransferred(address(0), _owner);
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(owner() == msg.sender, "Ownable: caller is not the owner");
        _;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

contract AI_Adaptive_Consensus is Ownable {
    using ConsensusLib for ConsensusLib.ConsensusParameters;

    // Event to log consensus parameter changes
    event ConsensusParametersUpdated(uint newBlockTime, uint newValidatorSetSize);

    ConsensusLib.ConsensusParameters private parameters;

    constructor(uint _initialBlockTime, uint _initialValidatorSetSize) {
        parameters.updateParameters(_initialBlockTime, _initialValidatorSetSize);
    }

    function updateConsensusParameters(uint _newBlockTime, uint _newValidatorSetSize) public onlyOwner {
        parameters.updateParameters(_newBlockTime, _newValidatorSetSize);
        emit ConsensusParametersUpdated(_newBlockTime, _newValidatorSetSize);
    }

    function simulateAIAdjustment() external onlyOwner {
        (uint newBlockTime, uint newValidatorSetSize) = AILib.simulateDecision(parameters.blockTime, parameters.validatorSetSize);
        updateConsensusParameters(newBlockTime, newValidatorSetSize);
    }

    function getConsensusParameters() public view returns (uint, uint) {
        return (parameters.blockTime, parameters.validatorSetSize);
    }
}
