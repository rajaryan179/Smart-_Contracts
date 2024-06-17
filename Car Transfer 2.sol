// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract CarMarket {

    enum CarStatus { ForSale, Sold, Insured, Financed, Registered }

    struct Car {
        address owner;
        string make;
        string model;
        uint256 price;
        CarStatus status;
    }

    mapping(uint256 => Car) public cars;
    uint256 public totalCars;

    event CarListed(uint256 indexed carId, string make, string model, uint256 price);
    event CarSold(uint256 indexed carId, address buyer, uint256 price);
    event CarInsured(uint256 indexed carId, address insurer);
    event CarFinanced(uint256 indexed carId, address financier);
    event CarRegistered(uint256 indexed carId, address government);

    modifier onlyOwner(uint256 _carId) {
        require(msg.sender == cars[_carId].owner, "You are not the owner of this car");
        _;
    }

    function listCar(string memory _make, string memory _model, uint256 _price) public {
        totalCars++;
        cars[totalCars] = Car(msg.sender, _make, _model, _price, CarStatus.ForSale);
        emit CarListed(totalCars, _make, _model, _price);
    }

    function buyCar(uint256 _carId) public payable {
        Car storage car = cars[_carId];
        require(car.status == CarStatus.ForSale, "Car is not for sale");
        require(msg.value >= car.price, "Insufficient funds");

        car.status = CarStatus.Sold;
        car.owner = msg.sender;
        payable(car.owner).transfer(msg.value);

        emit CarSold(_carId, msg.sender, msg.value);
    }

    function insureCar(uint256 _carId) public {
        Car storage car = cars[_carId];
        require(car.owner == msg.sender, "Only the owner can insure the car");

        car.status = CarStatus.Insured;

        emit CarInsured(_carId, msg.sender);
    }

    function financeCar(uint256 _carId) public {
        Car storage car = cars[_carId];
        require(car.owner == msg.sender, "Only the owner can finance the car");

        car.status = CarStatus.Financed;

        emit CarFinanced(_carId, msg.sender);
    }

    function registerCar(uint256 _carId) public {
        Car storage car = cars[_carId];
        require(car.owner == msg.sender, "Only the owner can register the car");

        car.status = CarStatus.Registered;

        emit CarRegistered(_carId, msg.sender);
    }
}
