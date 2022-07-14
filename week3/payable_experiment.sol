//SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

contract Test {

    // Execution cost 21407 gas (21250 w/ optimizer @1000)
    function doNothing() external pure returns (bool) {
        return true;
    }

    
    // Execution cost 21405 gas (21248 w/ optimizer @1000)
    function doNothingPayable() external payable returns (bool) {
        return true;
    }
    

    // Execution cost 21383 gas (21243 w/ optimizer @1000)
    function doNothingPayableWithProtection() external payable returns (bool) {
        require(msg.value == 0);
        return true;
    }
}