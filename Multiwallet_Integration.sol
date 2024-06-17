// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MultiwalletIntegration {
    address public owner;

    // Mapping to store user wallets
    mapping(address => address[]) private userWallets;

    // Events for logging
    event WalletConnected(address indexed user, address indexed wallet);
    event WalletDisconnected(address indexed user, address indexed wallet);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    // Function to connect a wallet
    function connectWallet(address _user, address _wallet) external onlyOwner {
        require(_user != address(0), "Invalid user address");
        require(_wallet != address(0), "Invalid wallet address");

        // Check if the wallet is not already connected
        require(!isWalletConnected(_user, _wallet), "Wallet already connected");

        // Connect the wallet
        userWallets[_user].push(_wallet);

        // Emit event
        emit WalletConnected(_user, _wallet);
    }

    // Function to disconnect a wallet
    function disconnectWallet(address _user, address _wallet) external onlyOwner {
        require(_user != address(0), "Invalid user address");
        require(_wallet != address(0), "Invalid wallet address");

        // Check if the wallet is connected
        require(isWalletConnected(_user, _wallet), "Wallet not connected");

        // Disconnect the wallet
        address[] storage wallets = userWallets[_user];
        for (uint256 i = 0; i < wallets.length; i++) {
            if (wallets[i] == _wallet) {
                // Remove the wallet from the list
                if (i < wallets.length - 1) {
                    wallets[i] = wallets[wallets.length - 1];
                }
                wallets.pop();

                // Emit event
                emit WalletDisconnected(_user, _wallet);
                break;
            }
        }
    }

    // Function to check if a wallet is connected for a user
    function isWalletConnected(address _user, address _wallet) public view returns (bool) {
        address[] memory wallets = userWallets[_user];
        for (uint256 i = 0; i < wallets.length; i++) {
            if (wallets[i] == _wallet) {
                return true;
            }
        }
        return false;
    }

    // Function to get the list of connected wallets for a user
    function getConnectedWallets(address _user) external view returns (address[] memory) {
        return userWallets[_user];
    }
}
