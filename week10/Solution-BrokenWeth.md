# Broken Weth

Initial thoughts on possible vulnerability:

- [ ] OZ Address lib known constructor vulnerability
- [ ] `balanceOf` public map comes w/ getter used by `borrow` func in the `LendBrokenWeth` HOWEVER `IBrokenWeth` comes with interface for `balanceOf` Perhaps override opportunity?
- [ ] `unwrap` function transfers funds before updating ledger
  - [ ] Within the `unwrap` function there is a `Address.sendValue` TX. The code base warns of a reentrancy attack here

How can we insert an overriden balance check that always returns `before` value (or ten)?