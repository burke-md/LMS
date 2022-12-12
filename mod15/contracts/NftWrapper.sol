// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

// import "hardhat/console.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract NftWrapper is Ownable {
    /**
    * TODO
    * implement 721 receiver
    * Check bytes -> address casting (abi.decodeAddress?)address decoded = abi.decode(_addr, (address));    
    */
    
    address immutable erc721Address;
    address immutable erc1155Address;

    constructor(address _erc721TokenAdrress, address _erc1155TokenAddress) {
        erc721Address = _erc721TokenAdrress;
        erc1155Address = _erc1155TokenAddress;
    }

    /**
     * @notice User must first grant privileged to this contract before wrapping.
      */
    function wrap(uint256 _id) external {
        // Check ownership
        (, bytes memory data1) = erc721Address.call(
            abi.encodeWithSignature("ownerOf(uint256)", _id));

        // Cast return value bytes memory to address for assertion
        address addr;
        assembly {
            addr := mload(add(data1,20))
        } 
        require(addr == msg.sender, 
            "1155 Wrap: User does not own this token.");

        // Transfer Nft to wrapper
        erc721Address.call(
            abi.encodeWithSignature("safeTransferFrom(address,address,uint256)", msg.sender, address(this), _id));

        // Mint 1155 wrapper to user and confirm.
        (bool isWrapped,) = erc1155Address.call(
            abi.encodeWithSignature("wrapperMint(address,uint256)", msg.sender, _id));
        require(isWrapped, "Wrapper unable to mint 1155");
    }

    function unwrap(uint256 _id) external {
        (,bytes memory numTokens ) = erc1155Address.call(
            abi.encodeWithSignature("balanceOf(address,uint256)", msg.sender, _id));
        
        uint256 decodedNumTokens = abi.decode(numTokens, (uint256));    

        require(decodedNumTokens == 1, 
            "Caller does not own wrapped token");
        // Burn 1155 wrapper token
        erc1155Address.call(
            abi.encodeWithSignature("wrapperBurn(address,uint256)", msg.sender, _id));
        // Transfer 721 back to user
        (bool isTransfered, ) = erc721Address.call(
            abi.encodeWithSignature("safeTransferFrom(address,address,uint256)", address(this), msg.sender, _id));
        require(isTransfered == true,
            "User did not receive ERC721 token.");
    }

    //721 receiver
}