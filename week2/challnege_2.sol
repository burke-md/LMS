//SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

contract TokenSale {

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

    /** @dev The onlyUnsanctioned modifier can be applied to any function within this contract.
    *        The modifier will revert any function if either the function caller or 
    *        intended recierver has been added to the sanctioned mapping.
    */

    modifier onlyUnsanctioned(address recipient) {
        require(sanctioned[msg.sender] == false, "Contract: You are not allowed to send tokens.");
        require(sanctioned[recipient] == false, "Contract: The recipient cannot recieve tokens.");
        _;
    }

    address public adminAddress;
    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance; 
    mapping(address => bool) public sanctioned;
    string public name = "Test token";
    string public symbol = "TST";
    uint8 public decimals = 18;

    /** @dev The toggelAccountSanction function acts as a 'setter' to toggle the boolean value associated with
    *        the sanctioned mapping and a given address.
    */

    function toggleAccountSanction(address _account) external {
        sanctioned[_account] = !sanctioned[_account];
    }

    function transfer(address recipient, uint256 amount) 
        external 
        onlyUnsanctioned(recipient) 
        returns (bool) {
            require(recipient != address(0));
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

    function _transfer(address from, address to, uint256 amount) internal {
        balanceOf[from] -= amount;
        balanceOf[to] += amount;
        emit Transfer(from, to, amount);
    }
}