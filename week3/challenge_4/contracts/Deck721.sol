// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract Deck20 is ERC721 {

    constructor() ERC721("rottenPlank", "RTP") {
    
        adminAddress = msg.sender; 
    }

    address immutable adminAddress;
    address constant erc20Address = "";
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
}

