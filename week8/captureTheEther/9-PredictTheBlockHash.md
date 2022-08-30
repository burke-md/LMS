# Predict the block hash

The magic answer is `0x0000000000000000000000000000000000000000000000000000000000000000`

Remarkable. 

But the trick here is that the block hash returns a hash of any of the previous 256 blocks *otherwise* it returns zero.

See the docs here:
https://docs.soliditylang.org/en/v0.8.11/units-and-global-variables.html#:~:text=(bytes32)%3A-,hash,-of%20the%20given

By locking in any value and then waiting for 257 blocks (roughly one hour) you can be sure that the value will be zero.