// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Deck20 is ERC20 {
    constructor() ERC20("rottenPlank", "RTP") {
        adminAddress = msg.sender; 
    }

    address private adminAddress;
    uint256 private constant tokenPrice = 0;

    modifier onlyAdmin() {
        require(msg.sender == adminAddress, 
                "Contract: This function is only available to the deployer.");
        _;
    }
   
    /** This is an open ended, free token.
    *   
    *   The tokens cost 0 Ether (see tokenPrice var above).
    * 
    *   There is no upper bound on how many can be purchased. 
    *
    */

    function purchaseTokens(uint256 _amount) external payable {
        require(msg.value == _amount * tokenPrice,
                "Contract: Incorect amount of Ether sent.");

        _mint(msg.sender, _amount);

    }

    function withdrawl(uint256 _amount) external onlyAdmin { 
        require(msg.sender == adminAddress, 
                "Contract: This function is only available to the deployer.");

        require(_amount <= address(this).balance,
                "Contract: Cannot withdrawl more than the contract holds.");

        payable(adminAddress).transfer(_amount);
    }

    receive() external payable {
        revert("Contract: Use 'purchaseTokens' functions to aquire tokens.");
    }

    fallback() external payable {
        revert("Contract: Use appropriate function for desired outcomes.");
    }

}
