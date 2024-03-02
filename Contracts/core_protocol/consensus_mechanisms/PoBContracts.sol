// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title IMONSI
 * @dev Basic interface for a MONSI contract.
 */
interface IMONSI {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
}

/**
 * @title PoBContracts
 * @dev Implements Proof of Burn for the MONSI coin.
 */
contract MONSI is IMONSI {
    mapping(address => uint256) private _balances;
    uint256 private _totalSupply;
    address public constant BURN_ADDRESS = 0x000000000000000000000000000000000000dEaD;

    event TokensBurned(address indexed burner, uint256 amount);

    constructor(uint256 initialSupply) {
        _totalSupply = initialSupply;
        _balances[msg.sender] = initialSupply;
        emit Transfer(address(0), msg.sender, initialSupply);
    }

    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        require(_balances[msg.sender] >= amount, "MONSI: transfer amount exceeds balance");
        _balances[msg.sender] -= amount;
        _balances[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    /**
     * @dev Burns a specific amount of tokens.
     * @param amount amount of tokens to be burned.
     */
    function burnTokens(uint256 amount) public {
        require(amount > 0, "MONSI: Amount to burn must be greater than 0.");
        require(_balances[msg.sender] >= amount, "MONSIToken: Burn amount exceeds balance.");

        _balances[msg.sender] -= amount;
        _totalSupply -= amount;

        emit TokensBurned(msg.sender, amount);
        emit Transfer(msg.sender, BURN_ADDRESS, amount);
    }
}
