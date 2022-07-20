// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

contract DeckStaking is IERC721Receiver {
    constructor() {
    
    }
    //Create struct to store staking data
    //Create mapping to store stake struct

    function onERC721Received(
        address operator, 
        address from, 
        uint256 tokenId, 
        bytes calldata data) external override returns (bytes4) {
            return IERC721Receiver.onERC721Received.selector;
    }     


    //Requirements:
    //User must be able to stake NFT(contract is to own NFT)
    function stake() external {
    //Note original owner, time stamp of stake
    //Make check for edge case (restake within rewardsHoldingTime)
    }
    
    //User must be able to reclaim NFT 
    function unstake() external {
    //Make check to ensure only original owner can unstake
    }

    /** Create func for users to withdrawl stake rewards 
    *   (see pull over push pattern)
    */

    function withdrawlRewards() external {

    }
}
