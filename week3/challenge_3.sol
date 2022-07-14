// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract MyToken is ERC721, ERC721URIStorage {
    constructor() ERC721("rottenPlank", "RTP") {}

    event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);

    mapping(uint256 => address) private _owners;
    mapping(address => mapping(address => bool)) private _operators;
    string baseURL = "";
    uint256 nextIdToMint = 10;

    function mint() external {
        require(nextIdToMint > 0);
        _owners[nextIdToMint] = msg.sender;
        nextIdToMint --;
        
    }

//----------------------------------------------------------------------------\\
//--------------------------------Overrides------------------------------------\\

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }
}