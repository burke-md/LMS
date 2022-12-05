// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

// import "hardhat/console.sol";

contract NftWrapper {
    
    address immutable erc721TokenAdrress;
    address immutable erc1155TokenAddress;

    constructor(address _erc721TokenAdrress, _erc1155TokenAddress) {
        erc721TokenAdrress = _erc721TokenAdrress;
        erc1155TokenAddress = _erc1155TokenAddress;
    }

    function wrap() external onlyOwner {

    }
}
