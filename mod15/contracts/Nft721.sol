// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

// import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/utils/structs/BitMaps.sol";

contract Nft721 is ERC721, Ownable {
    uint256 public constant PRICE = 0.05 ether;
    bytes32 public constant REGULAR_ROOT = 
        0x8e0ef294185666298e0e9e164a24f423ef8b331f7bbb115d326a226af878862b;

    // Recalculate BITMAP_ROOT TODO
    bytes32 public constant BITMAP_ROOT = 
        0x8e0ef294185666298e0e9e164a24f423ef8b331f7bbb115d326a226af8780000;
//---------------------------------------------------------------------------------\\

    constructor()  ERC721("StandardToken", "STD") {

    }

    using BitMaps for BitMaps.BitMap;

    BitMaps.BitMap private _bitmap;
//---------------------------------------------------------------------------------\\

    /**
     * Deployed as non zero value.
     * Users will not need to pay zero -> non zero feeds.
     */
    uint128 public hasPurchasedBitMap = 1000000000000000;

    uint256 public remainingTokens = 10;

    mapping (address => bool)  public hasPurchased;
//---------------------------------------------------------------------------------\\
    function mint() external payable {
        require(msg.value == PRICE, "Incorrect value sent.");
        decrementAvailableTokens();
        _safeMint(msg.sender, remainingTokens);
    }

    function whiteListMintMapping(bytes32[] calldata _proof) external payable {
        require(hasPurchased[msg.sender] == false, 
                "User has already made purchase.");
        require(msg.value == PRICE, "Incorrect value sent.");
        require(MerkleProof.verify(_proof, REGULAR_ROOT, toBytes32(msg.sender)) == true, 
                "Contract: Invalid proof.");

        hasPurchased[msg.sender] = true;
        decrementAvailableTokens();
        _safeMint(msg.sender, remainingTokens);
    }

    function whiteListMintBitmap(bytes32[] calldata _proof, uint8 _ticket) external payable {
        require(msg.value == PRICE, "Incorrect value sent.");

        /**
         * Check and flip bit - if user passes wrong _ticket value, merkle proof w/ address 
         * and ticket hash will revert, and bit status will not persist.
         */ 
        
        require(validateTicket(_ticket) == true, "Ticket could not be validated.");

        bytes32 leaf = keccak256((abi.encodePacked(msg.sender, _ticket)));
        require(MerkleProof.verify(_proof, REGULAR_ROOT, leaf) == true, 
                    "Contract: Invalid proof.");

        decrementAvailableTokens();
        _safeMint(msg.sender, remainingTokens);
    }

    function withdraw() external onlyOwner {

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
    }

    function validateTicket(uint256 _ticketNumber) internal returns (bool){
        require(_getBitMapIdx(_ticketNumber) == false, 
            "Ticket has already been punched.");

        _setBitMapIdx(_ticketNumber);

        return true;
    }

    function _getBitMapIdx(uint256 index) internal view returns (bool) {
        return _bitmap.get(index);
    }

    function _setBitMapIdx(uint256 index) internal {
        _bitmap.set(index);
    }

    function _unsetBitMapIdx(uint256 index) internal {
        _bitmap.unset(index);
    }
}
