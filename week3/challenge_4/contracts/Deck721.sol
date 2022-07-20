// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract Deck20 is ERC721 {
    constructor() ERC721("rottenPlank", "RTP") {
    
        adminAddress = msg.sender; 
    }

    address immutable adminAddress;
    address constant erc20Address = "";

    function mint() external payable {

    }

    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://Qm/";
    }

}

