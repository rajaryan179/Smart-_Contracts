// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract GameToken is ERC20, Ownable {
    constructor() ERC20("GameToken", "GTOK") {
        _mint(msg.sender, 1000000 * 10**decimals());
    }
}

contract GamePayment {
    GameToken public gameToken;
    address public gameOwner;

    event PaymentProcessed(address payer, uint256 amount);

    modifier onlyGameOwner() {
        require(msg.sender == gameOwner, "Only the game owner can call this function");
        _;
    }

    constructor(address _gameToken) {
        gameToken = GameToken(_gameToken);
        gameOwner = msg.sender;
    }

    function processPayment(address payer, uint256 amount) external onlyGameOwner {
        require(gameToken.balanceOf(payer) >= amount, "Insufficient funds");
        
        // Perform game-related actions here (e.g., provide in-game items, unlock levels, etc.)
        // ...

        // Transfer tokens from the payer to the game owner
        gameToken.transferFrom(payer, gameOwner, amount);

        emit PaymentProcessed(payer, amount);
    }
}
