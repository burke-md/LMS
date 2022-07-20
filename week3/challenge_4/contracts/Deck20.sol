// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Deck20 is ERC20 {
    constructor() ERC20("rottenPlank", "RTP") {
        adminAddress = msg.sender; 
    }

    address adminAddress;

    modifier onlyAdmin() {
        require(msg.sender == adminAddress, 
                "Contract: This function is only available to the deployer.");
        _;
    }
    
    function purchaseTokens(uint256 _amount) external payable {


    }

    function withdrawl(uint256 _amount) external onlyAdmin { 


    }

    receive() external payable {
        revert("Contract: Use 'purchaseTokens' functions to aquire tokens.");
    }

    fallback() external payable {
        revert("Contract: Use appropriate function for desired outcomes.");
    }

}
