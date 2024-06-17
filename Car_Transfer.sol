// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CarTransfer {
    address public owner;
    mapping(address => Car) public cars;

    struct Car {
        string make;
        string model;
        uint256 year;
        address ownerAddress;
    }

    event Transfer(address indexed from, address indexed to, string make, string model, uint256 year);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    function registerCar(string memory _make, string memory _model, uint256 _year) public {
        cars[msg.sender] = Car(_make, _model, _year, msg.sender);
    }

    function transferCar(address _to) public {
        Car storage car = cars[msg.sender];
        require(car.ownerAddress == msg.sender, "You don't own any car to transfer");
        require(_to != address(0), "Invalid address");

        car.ownerAddress = _to;

        emit Transfer(msg.sender, _to, car.make, car.model, car.year);
    }

    function getCarDetails(address _owner) public view returns (string memory, string memory, uint256, address) {
        Car memory car = cars[_owner];
        return (car.make, car.model, car.year, car.ownerAddress);
    }
}
