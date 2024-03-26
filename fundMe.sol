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

    // Could we make this constant?  /* hint: no! We should make it immutable! */
    address public /* immutable */owner;
    uint256 public constant MINIMUM_USD = 50 * 10 ** 18;
    
    constructor() {
       owner = msg.sender;
       i_owner= msg.sender;
    }

    function fund() public payable {
    require(msg.value >= MINIMUM_USD, "You need to spend more ETH!");

    // Check if the sender's address already exists in the funders array
    for (uint256 i = 0; i < funders.length; i++) {
        if (funders[i] == msg.sender) {
            revert AddressAlreadyExists(); // Revert if address already exists
        }
    }

    // Add the sender to the funders array
    funders.push(msg.sender);
    
    // Update the amount funded by the sender
    addressToAmountFunded[msg.sender] += msg.value;
}

    
    function getVersion() public view returns (uint256){
        // ETH/USD price feed address of Sepolia Network.
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x88A85688089C15ce061Cba7abd17913dc9A6F8cf);
        return priceFeed.version();
    }
    
    modifier onlyOwner {
        // require(msg.sender == owner);
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
        // // transfer
        // payable(msg.sender).transfer(address(this).balance);
        // // send
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send failed");
        // call
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
    }
    // Explainer from: https://solidity-by-example.org/fallback/
    // Ether is sent to contract
    //      is msg.data empty?
    //          /   \ 
    //         yes  no
    //         /     \
    //    receive()?  fallback() 
    //     /   \ 
    //   yes   no
    //  /        \
    //receive()  fallback()

    fallback() external payable {
        fund();
    }

    receive() external payable {
        fund();
    }

}

// Concepts we didn't cover yet (will cover in later sections)
// 1. Enum
// 2. Events
// 3. Try / Catch
// 4. Function Selector
// 5. abi.encode / decode
// 6. Hash with keccak256
// 7. Yul / Assembly


