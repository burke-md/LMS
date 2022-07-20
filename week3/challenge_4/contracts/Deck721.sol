// SPDX-License-Identifier: MIT 

pragma solidity 0.8.15; 

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract Deck20 is ERC721 {

    constructor() ERC721("rottenPlank", "RTP") {
    
        adminAddress = msg.sender; 
    }

    address immutable adminAddress;
    address private DECK_ERC20_ADDRESS  = "";
    uint256 private nextIdToMint = 10;

    function mint() external payable {
        uint256 currentIdIndex = nextIdToMint;
        require(currentIdIndex > 0, 
                "Contract: Minting would exceed max supply.");
        // handle erc20 payable
        _mint(msg.sender, currentIdIndex);
        nextIdToMint--;

    }

    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://Qm/";
    }

    function setERC20TokenAddress(address _address) external {
        require(msg.sender == adminAddress, 
                "Contract: This function is only available for the deployer.");
        DECK_ERC20_ADDRESS = _address;
    }
}

