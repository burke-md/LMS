# Token Bank

This is a more involved re-entrancy attack. It involves creating an attacking contract, a set up stage and then the actual attack. 

It is also important to note that the compiler version is < 0.8.0 and there is no SafeMath libs or extensive checks in sight.

## The setup:

- Withdraw tokens to wallet (500_000)
- Transfer tokens from wallet to attack contract
- Call function in attack contract which calls the transfer function within the token contract (not the bank, the ERC223 token)

``` 
        require(balanceOf[msg.sender] >= value);

        balanceOf[msg.sender] -= value;
        balanceOf[to] += value;
        emit Transfer(msg.sender, to, value);

        if (isContract(to)) {
            ITokenReceiver(to).tokenFallback(msg.sender, value, data);
        }
```

We can see above (transfer function in token contract) that the token transfer func is re-entrant safe and when all checks are passed will eventually call the `tokenFallBack` function in the bank. 

## The attack:

- Call withdraw from bank via the `attack` func in our attack contract

The previous transfer step has by now updated the balance of this attack contract in the bank's `balanceOf` map.

- Note the exposed interface that we have taken advantage of in our attacking contract

## The Contract:

Two things to note here:

- If we look back to the token's transfer function we can see there is a check, is the `to` address a contract? If so, call function `tokenFallback` which is exposed as an interface that we can implement. Re: our re-entrancy attack. 

- Because the withdraw operation subtracts the amount from our balance in the bank it is important to overflow this value, but then stop shortly after. 


```
uint8 counter = 2;

function attack() {
  ...
}

function tokenFallback(address from, uint256 value, bytes data) external {
  if (counter != 0) {
    counter--;
    victimInstance.withdraw(500000 * 10**18);
  } 
}

```


