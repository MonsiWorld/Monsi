// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IMONSI {
    // ERC-20 standard functions
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    // Minting and burning
    function mint(address to, uint256 amount) external;
    function burn(address from, uint256 amount) external;

    // Governance
    function delegate(address delegatee) external;
    function getVotes(address account) external view returns (uint256);

    // Events
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Minted(address indexed to, uint256 amount);
    event Burned(address indexed from, uint256 amount);
    event Delegation(address indexed delegatee, uint256 indexed delegationType);

    // Add more functions as necessary
}
