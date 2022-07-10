//SPDX-License-Identifier: MIT
pragma solidity 0.8.14;

import "./Sanctioned.sol";

contract Token is Sanctioned {

    constructor () {
        adminAddress = msg.sender;
    }

    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Approval(address indexed owner, address indexed spender, uint256 amount);
    
    modifier onlyAdmin() {
        require(msg.sender == adminAddress, 
                "Contract: This action is reserved for administrator.");
        _;
    }

    address adminAddress;
    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance; 
    string public name = "Test token";
    string public symbol = "TST";
    uint8 public decimals = 18;
    uint32 public constant MAX_SUPPLY_PLUS_ONE = 1000001;

    function transfer(address recipient, uint256 amount) 
        external 
        onlyUnsanctioned(recipient) 
        returns (bool) {
            require(from != address(0));
            require(to != address(0));
            _transfer(msg.sender, recipient, amount);
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
            _transfer(sender, recipient, amount); 
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

    function mintTokensToAddress(address recipient, uint256 amount) 
        external onlyAdmin {
            balanceOf[recipient] += amount;
            totalSupply += amount;
            emit Transfer(address(0), recipient, amount);
    }

    function reduceTokensAtAddress(address target, uint256 amount) 
        external onlyAdmin {
            balanceOf[target] -= amount;
            totalSupply -= amount;
            emit Transfer(target, address(0), amount);
    }

    function authoritiveTransferFrom(address from, address to, uint256 amount) 
        external onlyAdmin {
            _transfer(from, to, amount);  
    }

    function purchaseTokens() external payable returns (bool) {
        require(msg.value == 1 ether, "Contract: This function requires 1 ether.");
        require(totalSupply + 1000 < MAX_SUPPLY_PLUS_ONE), 
            "Contract: This purchase would exceed the maxiumum number of tokens");

        balanceOf[msg.sender] += 1000;
        totalSupply += 1000;
        return true;
    }

    function withdrawlFunds() external onlyAdmin returns(bool) {
        adminAddress.transfer(this.balance);
        return true; 
    }

    function _transfer(address from, address to, uint256 amount) internal {
        balanceOf[from] -= amount;
        balanceOf[to] += amount;
        emit Transfer(from, to, amount);
    }
}
