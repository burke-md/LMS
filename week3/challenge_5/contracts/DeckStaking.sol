// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

contract DeckStaking is IERC721Receiver {
    constructor(address _erc20Token, address _erc721Token) {
        DECK_20_TOKEN = _erc20Token;
        DECK_721_TOKEN = _erc721Token;
    }

    address public immutable DECK_20_TOKEN;
    address public immutable DECK_721_TOKEN;
    
    //Create struct to store staking data
    struct StakedToken {
        address owner;
        uint256 timeStamp;
    }
    //Create mapping to store stake struct
    mapping(uint256 => StakedToken) private stakes;//tokenId => struct

    function onERC721Received(
        address operator, 
        address from, 
        uint256 tokenId, 
        bytes calldata data) external override returns (bytes4) {
            return IERC721Receiver.onERC721Received.selector;
    }     

    //User must be able to stake NFT(contract is to own NFT)
    function stake(uint256 _tokenId) external {
        //Note original owner, time stamp of stake
        stakes[_tokenId] = StakedToken(msg.sender, block.timestamp);
        //Check ownership?? or will lack of ownership force reversion?

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
        //Should the staking contract be loaded with ERC20 tokens?
        //Other wise staking contract would need special privledge to transfer.

        //Should a check be made at time of staking for how many days could be
        //paid out?
    }
}
