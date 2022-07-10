//SPDX-License-Identifier: MIT

pragma solidity 0.8.14;

contract Sanctioned {

    mapping(address => bool) public sanctioned;

    /** @dev The onlyUnsanctioned modifier can be applied to any function within a contract that has 
    *        imported this file. The modifier will revert any function if either the function caller or 
    *        intended recierver has been added to the sanctioned mapping.
    */

    modifier onlyUnsanctioned(address recipient) {
        require(sanctioned[msg.sender] == false, "Contract: You are not allowed to send tokens.");
        require(sanctioned[recipient] == false, "Contract: The recipient cannot recieve tokens.");
        _;
    }

    /** @dev The toggelAccountSanction function acts as a 'setter' to toggle the boolean value associated with
    *        the sanctioned mapping and a given address.
    */

    function toggleAccountSanction(address _account) external {
        sanctioned[_account] = !sanctioned[_account];
    }
}
