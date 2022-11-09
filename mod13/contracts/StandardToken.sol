// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract StandardToken is ERC20 {
    constructor() ERC20("StandardToken", "STD") {
        _mint(msg.sender, 50_000 * 10 ** decimals());
    }
}
