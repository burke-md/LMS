// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract MyToken is ERC721, ERC721URIStorage {
    constructor() ERC721("rottenPlank", "RTP") {
        adminAddress = msg.sender; 
    }

    string private _baseUri = "ipfs://QmRiGbdFztn1KGLezBF76C2iqDJG4Rg4ZDs5wBEeRCP3z3/";
    uint256 private nextIdToMint = 10;
    address private adminAddress;

    function mint() external {
        uint256 tokenId = nextIdToMint;
        require(tokenId > 0);
         _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, _baseUri);
        nextIdToMint--;
    }

    function setMetaData(string memory _uri) external onlyAdmin {
        _baseUri = _uri;
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
        require(_exists(tokenId), "Contract: This token does not yet exist");
        return string(abi.encodePacked(_baseUri, uint2str(tokenId)));
    }

//----------------------------------------------------------------------------\\
//---------------------------------Helpers-------------------------------------\\

     /** @notice The uint2str function is a helper for handling the 
    *   concatenation of string numbers.
    */
    function uint2str(uint _int) internal pure returns (string memory) {
        if (_int == 0) {
            return "0";
        }
        uint j = _int;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len - 1;
        while (_int != 0) {
            unchecked { bstr[k--] = bytes1(uint8(48 + _int % 10)); }
            _int /= 10;
        }
        return string(bstr);
    }
//----------------------------------------------------------------------------\\
//---------------------------------Access-------------------------------------\\

    modifier onlyAdmin() {
        require(msg.sender == adminAddress, 
            "Contract: This function is only available to the contract admin.");
        _;
    }
}
