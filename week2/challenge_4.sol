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

     /** @dev The onlyUnsanctioned modifier can be applied to any function within a contract that has 
    *        imported this file. The modifier will revert any function if either the function caller or 
    *        intended recierver has been added to the sanctioned mapping.
    */

    modifier onlyUnsanctioned(address recipient) {
        require(sanctioned[msg.sender] == false, "Contract: You are not allowed to send tokens.");
        require(sanctioned[recipient] == false, "Contract: The recipient cannot recieve tokens.");
        _;
    }

    address adminAddress;
    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance; 
    mapping(address => bool) public sanctioned;
    string public name = "Test token";
    string public symbol = "TST";
    uint8 public decimals = 18;
    uint32 public constant MAX_SUPPLY_PLUS_ONE = 1000001;

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

    function purchaseTokens() external payable returns (bool) {
        require(msg.value == 1 ether, "Contract: This function requires 1 ether.");
        require(totalSupply + 1000 < MAX_SUPPLY_PLUS_ONE ||
                balanceOf[address(this)] >= 1000 ether, 
            "Contract: There are not enough tokens available for sale at this time.");

        
        if ( totalSupply + 1000 < MAX_SUPPLY_PLUS_ONE ) {
            balanceOf[msg.sender] += 1000;
            totalSupply += 1000;
            return true;
        }
        
        // If max supply has been reached BUT the contract holds token, they can
        // be sold via this transfer (second require statment would force revert
        // if this is not possible).
        _transfer(address(this), msg.sender, 1000);
       return true; 
    }

    function withdrawlFunds() external onlyAdmin returns(bool) {
        payable(adminAddress).transfer(address(this).balance);
        return true; 
    }

    /** @notice tradeInTokens is a function to redeem 'blocks' of 1000
    *   tokens in for 0.5 ETH. This functions can process several 'blocks'
    *   at a time.
    *
    *   @notice tradeInTokens requires that this contract first be approved
    *   to transfer the appropriate number of tokens before being called. 
    */

    function tradeInTokens(uint256 _amount) external {
        uint256 blocks = _amount/1000;
        require(_amount % 1000 == 0, 
                "Contract: trade in amount must be devisible by 1000."); 
        require(allowance[msg.sender][address(this)] >= _amount, 
                "Contract: User must first give permission to contract.");
        require(address(this).balance >= 500000000000000000 * blocks, 
                "Contract: There are insufficient funds to refund your tokens at this time.");
        _transfer(msg.sender, address(this), _amount);
        payable(msg.sender).transfer(500000000000000000 * blocks);
    }

    function _transfer(address from, address to, uint256 amount) internal {
        balanceOf[from] -= amount;
        balanceOf[to] += amount;
        emit Transfer(from, to, amount);
    }

    /** @dev  setTokenSupply is for testing purposes only 
    *        TO BE REMOVED
    */

    function setTokenSupply() external {
        totalSupply = 1000000;
    }
}