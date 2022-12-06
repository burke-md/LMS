// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

// import "hardhat/console.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";

contract NftWrapper is Ownable {
    
    IERC721 immutable erc721Token;
    IERC1155 immutable erc1155Token;

    constructor(address _erc721TokenAdrress, address _erc1155TokenAddress) {
        erc721Token = IERC721(_erc721TokenAdrress);
        erc1155Token = IERC1155(_erc1155TokenAddress);
    }

    function wrap() external {

    }

    function unwrap() external {

    }
}
