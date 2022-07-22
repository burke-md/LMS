// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract DeckStaking is IERC721Receiver {
    constructor(address _erc20Token, address _erc721Token) {
        DECK_20_TOKEN = _erc20Token;
        DECK_721_TOKEN = _erc721Token;
    }

    address public immutable DECK_20_TOKEN;
    address public immutable DECK_721_TOKEN;
    uint256 public timeToReward = 10; 

    /** @notice This example does not directly use original time of stake, 
    *   however, this would likely be used to improve UX in prod.
    */

    struct StakedToken {
        address owner;
        uint256 originStakeTime;
        uint256 lastWithdrawl;
    }

    mapping(uint256 => StakedToken) private stakes;//tokenId => struct

    function onERC721Received(
        address operator, 
        address from, 
        uint256 tokenId, 
        bytes calldata data) external override returns (bytes4) {
            return IERC721Receiver.onERC721Received.selector;
    }     

    /** @notice Before calling the stake function, users must enable this 
    *   contract to transfer your NFT.
    */

    function stake(uint256 _tokenId) external {
        
        if (stakes[_tokenId].lastWithdrawl + timeToReward < block.timestamp) {
            revert("Contract: This token has recently been staked. Please try later!");
        }

        IERC721(DECK_721_TOKEN).safeTransferFrom(msg.sender, address(this), _tokenId);

         //Last withdrawl set to time of stake, updated as token rewards are withdrawn.
        stakes[_tokenId] = StakedToken(msg.sender, block.timestamp, block.timestamp);
    }
    
    function unstake(uint256 _tokenId) external {
        require(stakes[_tokenId].owner == msg.sender,
                "Contract: Only a token's owner can unstake.");

        IERC721(DECK_721_TOKEN).safeTransferFrom(address(this), msg.sender, _tokenId);
        
        //Emit unstake event

    }

    function withdrawlRewards(uint256 _tokenId) external {
        // (Current time - time of stake) / how long for rewards 
        require((block.timestamp - stakes[_tokenId].lastWithdrawl) > timeToReward,
                    "Contract: Enough time has not passed, to collect reward.");
       
        require(stakes[_tokenId].owner == msg.sender,
                "Contract: User must own token to withdrawl funds.");

        stakes[_tokenId].lastWithdrawl = block.timestamp;

        IERC20(DECK_20_TOKEN).transferFrom(address(this), msg.sender, 10e18);
    }

    /** @notice Users may want to check that this contract has access to reward
    *   tokens, before staking.
    */
    function hasRewardTokens() external view returns (uint256) {
        uint256 _balance = IERC20(DECK_20_TOKEN).balanceOf(address(this));
        return _balance;
    }
}
