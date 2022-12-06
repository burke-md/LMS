// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

// import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Nft721 is ERC721, Ownable {
    uint256 public constant PRICE = 0.05 ether;

    mapping (address => bool)  public hasPurchased;

    constructor()  ERC721("StandardToken", "STD") {

    }
    
    uint256 public remainingTokens = 10;
//---------------------------------------------------------------------------------\\
    function mint() external payable {
        require(msg.value == PRICE, "Incorrect value sent.");
        // verify contract state (remaingin tokens/ enum)

        decrementAvailableTokens();
        _safeMint(msg.sender, remainingTokens);
    }

    function whiteListMintMapping(bytes calldata _proof) external payable {
        require(hasPurchased[msg.sender] == false, 
                "User has already made purchase.");
        require(msg.value == PRICE, "Incorrect value sent.");
        // verify contract state (remaingin tokens/ enum)

        hasPurchased[msg.sender] = true;
        decrementAvailableTokens();
        _safeMint(msg.sender, remainingTokens);
    }

    function whiteListMintBitmap(bytes calldata _proof) external payable {
        //Make bitmap check
        require(msg.value == PRICE, "Incorrect value sent.");
        // verify contract state (remaingin tokens/ enum)

        decrementAvailableTokens();
        _safeMint(msg.sender, remainingTokens);
    }

    function withdraw() external onlyOwner {

    }

    function decrementAvailableTokens() internal {
        --remainingTokens;
        if (remainingTokens == 0) {
            //set enum
        }
    }

    function setContractState() external onlyOwner {
        //Update state enum
    }
}
