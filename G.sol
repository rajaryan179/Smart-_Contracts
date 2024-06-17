// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Import the ERC-20 interface for token functionality
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// Define your GoldCoin contract, inheriting from ERC20 and Ownable
contract GoldCoin is ERC20("Gold Coin", "GOLD"), Ownable {
    // Define the initial supply and set it to the contract creator
    uint256 public initialSupply;

    // Constructor function to initialize the contract
    constructor(uint256 _initialSupply) {
        initialSupply = _initialSupply;
        // Mint the initial supply and assign it to the contract creator (owner)
        _mint(msg.sender, _initialSupply * 10 ** uint256(decimals()));
    }

    // Mint additional tokens (only callable by the owner)
    function mint(uint256 _amount) public onlyOwner {
        _mint(msg.sender, _amount * 10 ** uint256(decimals()));
    }

    // Burn tokens (only callable by the owner)
    function burn(uint256 _amount) public onlyOwner {
        _burn(msg.sender, _amount * 10 ** uint256(decimals()));
    }
}
