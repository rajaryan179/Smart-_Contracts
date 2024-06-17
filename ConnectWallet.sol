// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ConnectWallet {
    address public connectedWallet;
    
    // Event to log the wallet connection
    event WalletConnected(address walletAddress);
    
    // Modifier to check if the wallet is connected
    modifier onlyConnectedWallet() {
        require(msg.sender == connectedWallet, "Caller is not the connected wallet");
        _;
    }
    
    // Function to connect wallet
    function connectWallet() external {
        connectedWallet = msg.sender;
        emit WalletConnected(msg.sender);
    }
    
    // Function to get the connected wallet's address
    function getConnectedWalletAddress() external view returns (address) {
        return connectedWallet;
    }
    
    // Function to get the balance of the connected wallet
    function getConnectedWalletBalance() external view onlyConnectedWallet returns (uint256) {
        return address(connectedWallet).balance;
    }
}
