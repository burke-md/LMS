// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "./Clones.sol";

contract CloneMaker {
    constructor () {}

    using Clones for *;

    function createClone(address _implementation) external returns(address) {
        return Clones.clone(_implementation);
    }
}
