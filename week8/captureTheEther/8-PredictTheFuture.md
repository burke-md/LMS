# Predict the Future

Much the same as the last challenge we can programatically calculate the has OR spam the contract as the value will be between 0-9.

```uint8 answer = uint8(keccak256(block.blockhash(block.number - 1), now)) % 10;```

We can see this is because of the mod operator.