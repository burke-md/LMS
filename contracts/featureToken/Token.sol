//SPDX-License-Identifier: MIT
pragma solidity 0.8.14;

import "./Sanctioned.sol";

contract Token is Sanctioned {

    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Approval(address indexed owner, address indexed spender, uint256 amount);

    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance; // owner => (spender => amount)
    string public name = "Test token";
    string public symbol = "TST";
    uint8 public decimals = 18;

    function transfer(address recipient, uint256 amount) external onlyUnsanctioned(recipient) returns (bool) {
        _transfer(recipient, msg.sender, amount);
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
            balanceOf[sender] -= amount;
            balanceOf[recipient] += amount;
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

    function _transfer(address to, address from, uint256 amount) internal {
        require(from != address(0));
        require(to != address(0));

        balanceOf[from] -= amount;
        balanceOf[to] += amount;
        emit Transfer(from, to, amount);
    }
}
