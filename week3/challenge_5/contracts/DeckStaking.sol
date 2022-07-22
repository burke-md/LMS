// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract DeckStaking is IERC721Receiver {
    constructor(address _erc20Token, address _erc721Token) {
        DECK_20_TOKEN = _erc20Token;
        DECK_721_TOKEN = _erc721Token;
        adminAdress = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == adminAdress,
                "Contract: This function is only available to contract admin.");
        _;
    }

    address public adminAdress;
    address public immutable DECK_20_TOKEN;
    address public immutable DECK_721_TOKEN;
    uint256 public timeToReward = 10; //check date formating

    //Create struct to store staking data
    struct StakedToken {
        address owner;
        uint256 originStakeTime;
        uint256 lastWithdrawl;
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

    //Make check for edge case (restake within rewardsHoldingTime)
    /** Point of interest: Should address or tokenId be observed to prevent 
    *   restake for quick rewards edge case? 
    *   
    *   Address: New owner would not face lock out time - one owner could just
    *   transer between wallets and restake.
    * 
    *   tokenId: Easily prevent this issue - new owner face unwarented lockout.
    *   If staking rewards were significant enough, user may want access to last
    *   staking time stamp info before purchase  of "spent" NFT.
    *
    */ 

        if (stakes[_tokenId].lastWithdrawl + timeToReward < block.timestamp) {
            revert("Contract: This token has recently been staked. Please try later!");
        }

        // user needs to allow transfer form this contract address
        //Check ownership?? or will lack of ownership force reversion?
        IERC721(DECK_721_TOKEN).safeTransferFrom(msg.sender, address(this), _tokenId);

         //Owner, time of stake, last withdrawl (set to time of stake, updated as 
         //token rewards are withdrawn.
        stakes[_tokenId] = StakedToken(msg.sender, block.timestamp, block.timestamp);
    }
    
    //User must be able to reclaim NFT 
    function unstake(uint256 _tokenId) external {
    //Make check to ensure only original owner can unstake
        require(stakes[_tokenId].owner == msg.sender,
                "Contract: Only a token's owner can unstake.");

        IERC721(DECK_721_TOKEN).safeTransferFrom(address(this), msg.sender, _tokenId);
        
        //Emit unstake event

    }

    /** Create func for users to withdrawl stake rewards 
    *   (see pull over push pattern)
    */

    function withdrawlRewards(uint256 _tokenId) external {
        // (Current time - time of stake) / how long for rewards 
        require((block.timestamp - stakes[_tokenId].lastWithdrawl) > timeToReward,
                    "Contract: Enough time has not passed, to collect reward.");
        
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
