// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "./PriceConverter.sol";

error NotOwner();
error AddressAlreadyExists();

contract FundMe {
    using PriceConverter for uint256;
address public i_owner;
    mapping(address => uint256) public addressToAmountFunded;
    address[] public funders;

    address public owner;
    uint256 public constant MINIMUM_USD = 50 * 10 ** 18;
    
    constructor() {
       owner = msg.sender;
       i_owner= msg.sender;
    }

    function fund() public payable {
    require(msg.value >= MINIMUM_USD, "You need to spend more ETH!");

    for (uint256 i = 0; i < funders.length; i++) {
        if (funders[i] == msg.sender) {
            revert AddressAlreadyExists(); 
        }
    }

    funders.push(msg.sender);
    
    addressToAmountFunded[msg.sender] += msg.value;
}

    
    function getVersion() public view returns (uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x88A85688089C15ce061Cba7abd17913dc9A6F8cf);
        return priceFeed.version();
    }
    
    modifier onlyOwner {
        if (msg.sender!=i_owner) revert NotOwner();
        _;
    }

    function transferOwnership(address newOwner) public onlyOwner {
    require(newOwner != address(0), "New owner cannot be zero address");
   owner = newOwner;
}

    function withdraw() public onlyOwner {
        for (uint256 funderIndex=0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0);
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
    }

    fallback() external payable {
        fund();
    }

    receive() external payable {
        fund();
    }

}

