# Broken Weth

Initial thoughts on possible vulnerability:

- [ ] OZ Address lib known constructor vulnerability
- [ ] `balanceOf` public map comes w/ getter used by `borrow` func in the `LendBrokenWeth` HOWEVER `IBrokenWeth` comes with interface for `balanceOf` Perhaps override opportunity?

How can we insert an overriden balance check that always returns `before` value (or ten)?