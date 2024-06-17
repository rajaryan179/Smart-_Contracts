// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

   contract ICO is Ownable,ERC20, Pausable {
    address public admin;
    uint256 public tokenPrice;
    uint256 public maxTokens;
    uint256 public tokensSold;
    bool public ICOActive;

    event TokensPurchased(address indexed buyer, uint256 amount, uint256 totalPrice);
    event TokensSold(address indexed seller, address indexed buyer, uint256 amount);

    constructor(
        string memory _HelixToken,
        string memory _HLX,
        uint256 _initialSupply,
        uint256 _tokenPrice,
        uint256 _maxTokens
    ) ERC20(_HelixToken, _HLX) {
        _mint(msg.sender, _initialSupply);
        admin = msg.sender;
        tokenPrice = _tokenPrice;
        maxTokens = _maxTokens;
        tokensSold = 0;
        ICOActive = true;
    }
      mapping(address => uint256) public balances;

    function invest() public payable whenNotPaused {
        balances[msg.sender] += msg.value;
    }

    function withdraw() public onlyOwner {
        
        payable(owner()).transfer(address(this).balance);
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can call this function");
        _;
    }

    function setTokenPrice(uint256 _newPrice) external onlyAdmin {
        tokenPrice = _newPrice;
    }

    function setMaxTokens(uint256 _newMaxTokens) external onlyAdmin {
        maxTokens = _newMaxTokens;
    }

    function toggleICOStatus() external onlyAdmin {
        ICOActive = !ICOActive;
    }

    function buyTokens(uint256 _numTokens) external payable whenNotPaused {
        require(ICOActive, "ICO is not active");
        require(_numTokens > 0, "Number of tokens must be greater than 0");
        require(tokensSold + _numTokens <= maxTokens, "Not enough tokens left for sale");

        uint256 totalPrice = _numTokens * tokenPrice;
        require(msg.value >= totalPrice, "Insufficient Ether sent");

        _mint(msg.sender, _numTokens);
        tokensSold += _numTokens;
        emit TokensPurchased(msg.sender, _numTokens, totalPrice);
    }

    function sellTokens(uint256 _numTokens) external whenNotPaused {
        require(balanceOf(msg.sender) >= _numTokens, "Insufficient tokens balance");
        require(ICOActive == false, "ICO is still active, cannot sell tokens");

        uint256 totalPrice = _numTokens * tokenPrice;
        _burn(msg.sender, _numTokens);
        tokensSold -= _numTokens;
        payable(msg.sender).transfer(totalPrice);
        emit TokensSold(msg.sender, admin, _numTokens);
    }

    function withdrawFunds() external onlyAdmin {
        require(address(this).balance > 0, "No funds available for withdrawal");
        payable(admin).transfer(address(this).balance);
    }

    receive() external payable {
        
    }
}

