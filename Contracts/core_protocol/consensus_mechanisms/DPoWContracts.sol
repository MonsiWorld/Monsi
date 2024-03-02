// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DPoWContracts {
    struct Delegate {
        bool isAuthorized;
        uint256 workCount; // Number of successful work submissions
    }

    address public admin;
    mapping(address => Delegate) public delegates;
    uint256 public currentDifficulty; // Simplified difficulty representation

    event DelegateAuthorized(address indexed delegate);
    event WorkSubmitted(address indexed delegate, uint256 nonce, bool isValid);
    event DifficultyAdjusted(uint256 newDifficulty);

    modifier onlyAdmin() {
        require(msg.sender == admin, "DPoWContracts: Only admin can perform this action.");
        _;
    }

    modifier onlyAuthorizedDelegate() {
        require(delegates[msg.sender].isAuthorized, "DPoWContracts: Not an authorized delegate.");
        _;
    }

    constructor(uint256 _initialDifficulty) {
        admin = msg.sender;
        currentDifficulty = _initialDifficulty;
    }

    // Admin authorizes a delegate to submit work
    function authorizeDelegate(address _delegate) external onlyAdmin {
        delegates[_delegate].isAuthorized = true;
        emit DelegateAuthorized(_delegate);
    }

    // Delegate submits their proof of work (nonce), which is a simplified validation
    function submitWork(uint256 nonce) external onlyAuthorizedDelegate {
        bool isValid = validateWork(nonce);
        if (isValid) {
            delegates[msg.sender].workCount += 1;
        }
        emit WorkSubmitted(msg.sender, nonce, isValid);
    }

    // Adjust the difficulty, simulating dynamic network conditions
    function adjustDifficulty(uint256 _newDifficulty) external onlyAdmin {
        currentDifficulty = _newDifficulty;
        emit DifficultyAdjusted(_newDifficulty);
    }

    // Simplified work validation based on current difficulty
    function validateWork(uint256 nonce) internal view returns (bool) {
        // This is a highly simplified placeholder for real PoW validation logic
        uint256 hash = uint256(keccak256(abi.encodePacked(nonce))) % 1000;
        return hash < currentDifficulty;
    }
    
    uint256 private nonceChallenge;
    uint256 public constant MAX_DIFFICULTY = 10**18; // Max difficulty setting for scaling
    
    // Function to adjust the nonce challenge for the next work submission
    function updateNonceChallenge() internal {
        // Pseudo-random update of the challenge based on block information
        nonceChallenge = uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, nonceChallenge))) % MAX_DIFFICULTY;
    }

    // Adjust the difficulty, simulating dynamic network conditions
    // Updated to also refresh the nonce challenge
    function adjustDifficulty(uint256 _newDifficulty) external onlyAdmin {
        require(_newDifficulty <= MAX_DIFFICULTY, "DPoWContracts: Difficulty exceeds maximum.");
        currentDifficulty = _newDifficulty;
        updateNonceChallenge(); // Ensure a new challenge on difficulty adjustment
        emit DifficultyAdjusted(_newDifficulty);
    }

    // Improved work validation based on current difficulty and a nonce challenge
    function validateWork(uint256 nonce) internal returns (bool) {
        // Enhanced pseudo-random challenge check
        uint256 hash = uint256(keccak256(abi.encodePacked(nonce, nonceChallenge)));

        // The valid hash range is adjusted dynamically based on the currentDifficulty
        bool isValid = hash % MAX_DIFFICULTY < currentDifficulty;

        if (isValid) {
            updateNonceChallenge(); // Update challenge for the next submission
        }

        return isValid;
    }
}
