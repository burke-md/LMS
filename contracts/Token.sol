//SPDX-License-Identifier: MIT
pragma solidity 0.8.14;

contract Token {
    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Approval(address indexed owner, address indexed spender, uint256 amount);

    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;
    //      owner => (spender => amount)
    mapping(address => mapping(address => uint256)) public allowance;
    string public name = "Test token";
    string public symbol = "TST";
    uint8 public decimals = 18;

    function transfer(address recipient, uint256 amount) external returns (bool){
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }
    
    function approve(address spender, uint256 amount) external returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }       

    function transerFrom(address sender, address recipient, uint256 amount) 
        external returns (bool) {
            allowance[sender][msg.sender] -= amount; 
            // The built in underflow protection (as of solidity 8) will
            // force this to revert if there is insuficient or no allowance 
            // at all.

            balanceOf[sender] -= amount;
            balanceOf[recipient] += amout;
            emit Transfer(sender, recipient, amount);
            return true;
    }   

    function mint(uint256 amount) external {
        balanceOf[msg.sender] += amount;
        totalSupply += amount;
        emit Transfer(address(0), msg.sender, amount);
    }

    function burn(uint256 amount) external {
        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;
        emit Transfer(msg.sender, address(0), amount);
    }
}
