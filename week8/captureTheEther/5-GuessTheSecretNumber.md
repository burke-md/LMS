# Guess the Secret Number

```pragma solidity 0.8.0;

contract BruteForce {
        bytes32 targetHash = 0xdb81b4d58595fbbbb592d3661a34cdca14d7ab379441400cbfa1b78bc447c365;

        function findMatch() public view returns(uint8) {
            for (uint8 i = 0 ; i < 256; i++) {
                if (keccak256(abi.encodePacked(i)) == targetHash) {
                    return i;
                }
            }
        }
}
````

In theory a one way cryptographic hash is quite secure but because of the accepted input from the victim contract we know that the value is a uint8.
This means the value in base ten will be between 0-255 => small enough to comfortable brute force.
