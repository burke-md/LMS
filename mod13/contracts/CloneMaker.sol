// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "./Clones.sol";
import "./StandardToken.sol";

contract CloneMaker {
    constructor () {}

    using Clones for *;

    function createClone(address _implementationAddress, uint256 _supply, string memory _name, string memory _symbol, address _owner) external returns(address) {
        address newContractAddress = Clones.clone(_implementationAddress);

        StandardToken newContract = StandardToken(newContractAddress);
        newContract.initialize(_supply, _name, _symbol, _owner);

        return newContractAddress;
    }
}