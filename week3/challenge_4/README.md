# Exchange ERC20 tokens for ERC721 NFT

This repo is a demo project. It glosses over several implementation details,
however, can be easily tested on Remix by following the below steps.

- Deploy both contracts(Deck20.sol, Deck721.sol)

- Purchase tokens from ERC20 contract (note NFT mint will cost 10 tokens w/ 18 
  decimal places. Mint w/ value 10000000000000000000)

- Set the ERC20 contract address in the ERC721 contract (So the NFT knows which 
  tokens to accept as payment) This will need to be done by the deployer.

- Increase the allowance between ERC721 contract and the user wallet address

- Mint NFT from ERC721 contract (review ERC20 token balance and note decresed value)
