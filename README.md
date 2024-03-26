FundMe Contract

Description
This Solidity contract, FundMe, facilitates crowdfunding by allowing users to contribute Ethereum (ETH) to a fund. It leverages blockchain oracles, specifically the Chainlink Price Feeds, to determine the USD value of the contributed ETH. The contract owner can withdraw the accumulated ETH from the fund.

Components
FundMe.sol
 Contract: FundMe
   State Variables:
     owner: Address of the contract owner.
     MINIMUM_USD: Minimum amount in USD required for a contribution.
     i_owner: Immutable address of the contract owner.
     addressToAmountFunded: Mapping of addresses to the amount of ETH theyve contributed.
     funders: Array containing addresses of contributors.
   Functions:
     fund(): Allows users to contribute ETH to the fund.
     getVersion(): Retrieves the version of the ETH/USD price feed.
     transferOwnership(address newOwner): Allows the contract owner to transfer ownership.
     withdraw(): Allows the contract owner to withdraw ETH from the fund.
     fallback(): Fallback function to accept ETH contributions.
     receive(): Receive function to accept ETH contributions.
   Modifiers:
     onlyOwner: Restricts functions to be callable only by the contract owner.

 PriceConverter.sol
 Library: PriceConverter
   Functions:
     getPrice(): Retrieves the latest ETH/USD price from Chainlink Price Feeds.
     getConversionRate(uint256 ethAmount): Converts the specified amount of ETH to USD.

 Usage
1. Deploy the FundMe contract on a supported blockchain network.
2. Users can contribute ETH to the contract using the fund() function.
3. The contract owner can withdraw accumulated ETH using the withdraw() function.
4. Ensure proper configuration of Chainlink Price Feeds for accurate conversion rates.

 SPDXLicenseIdentifier
 MIT

 Contributors
 Aditya Singh
 kalavatiaditya@gmail.com
