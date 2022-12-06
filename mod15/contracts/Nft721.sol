// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

// import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract Nft721 is ERC721, Ownable {
    uint256 public constant PRICE = 0.05 ether;
    bytes32 public constant REGULAR_ROOT = 0x8e0ef294185666298e0e9e164a24f423ef8b331f7bbb115d326a226af878862b;
    // Recalculate BITMAP_ROOT
    bytes32 public constant BITMAP_ROOT = 0x8e0ef294185666298e0e9e164a24f423ef8b331f7bbb115d326a226af8780000;

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

    function whiteListMintMapping(bytes32[] calldata _proof) external payable {
        require(hasPurchased[msg.sender] == false, 
                "User has already made purchase.");
        require(msg.value == PRICE, "Incorrect value sent.");
        // verify contract state (remaingin tokens/ enum)
        require(MerkleProof.verify(_proof, REGULAR_ROOT, toBytes32(msg.sender)) == true, 
                    "Contract: Invalid proof.");

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

    function setContractState() external onlyOwner {
        //Update state enum
    }

//---------------------------------------------------------------------------------\\
    /** @notice The toBytes32 function is a helper to handle casting an address
    *   to bytes32.
    */
    function toBytes32(address addr) pure internal returns (bytes32) {
        return bytes32(uint256(uint160(addr)));
    }

    function decrementAvailableTokens() internal {
        --remainingTokens;
        if (remainingTokens == 0) {
            //set enum
        }
    }
}
