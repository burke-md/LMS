# Clone

## Gas costs
```shell
Deploying CloneMaker contract                   : 288_915 gas 
Deploying ERC20 StandardToken contract          : 2_756_281 gas
Calling createClones (new clone and initialize) : 212_723 gas
```
## Testing

At this time I am deploying these contracts on Remix and testing manually. 
- Deploy `CloneMaker.sol` which imports from the `Clones.sol` library
- Deploy `CloneTester.sol`
- Deploy `StandardToken.sol` as an upgradable contract (Select deploy w/ proxy)

- Use `createClone` from the `CloneMaker.sol` contract to clone the implementation of the StandardToken.
This function also initializes the contract. 


## See also:

- Ethernaut repo
- Damn vulnerable repo