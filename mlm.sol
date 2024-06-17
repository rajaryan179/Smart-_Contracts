// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MLMContract {
    address public owner;
    
    struct User {
        address[] referrals;
        uint256 totalEarnings;
    }
    
    mapping(address => User) public users;
    
    event ReferralBonus(address indexed referrer, address indexed referral, uint256 bonus);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function enroll() external {
        require(users[msg.sender].referrals.length == 0, "User already enrolled");
        users[msg.sender].referrals.push(address(0)); // Placeholder for the direct referrer
    }

    function refer(address _referral) external {
        require(users[msg.sender].referrals.length > 0, "User not enrolled");
        require(users[_referral].referrals.length > 0, "Referral not enrolled");

        users[msg.sender].referrals.push(_referral);
        emit ReferralBonus(_referral, msg.sender, calculateReferralBonus());
    }

    function calculateReferralBonus() internal pure returns (uint256) {
    // Implement your commission structure logic here
    // This is a placeholder, you may want to customize based on your MLM plan
    return 0.01 ether;
    }


    function withdraw() external {
        uint256 earnings = users[msg.sender].totalEarnings;
        require(earnings > 0, "No earnings to withdraw");

        users[msg.sender].totalEarnings = 0;
        payable(msg.sender).transfer(earnings);
    }

    function getReferrals(address _user) external view returns (address[] memory) {
        return users[_user].referrals;
    }

    function getTotalEarnings(address _user) external view returns (uint256) {
        return users[_user].totalEarnings;
    }

    function contractBalance() external view onlyOwner returns (uint256) {
        return address(this).balance;
    }
}
