# Clone

## Gas costs
```shell
Deploying Clones contract               :
Deploying ERC20 StandardToken contract  :
Calling Clones to redeploy StandardToken:
```
## Testing

At this time I am deploying these contracts on Remix and testing manually. 
- Deploy `CloneMaker.sol` which imports from the `Clones.sol` library
- Deploy `CloneTester.sol`
- Deploy `StandardToken.sol` as an upgradable contract (Select deploy w/ proxy)

- Use `createClone` from the `CloneMaker.sol` contract to clone the implementation of the StandardToken
- Call the initialize function manually => This will need to be smoothed out but will potentially allow for dynamic initialization of clones

```shell
npx hardhat help
npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat node
npx hardhat run scripts/deploy.ts
```
