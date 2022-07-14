# ERC721 & ERC1155

The core difference here is that while a ERC20 token allows many of one token type to be minted and the ERC1155 standard allows many of multiple token types to be minted/transferred/burned etc. 

With each new token "type" in an 1155 being distinguished by the tokenId, this can be seen in the transfer function.

ERC20: ```_transfer(owner, to, amount)```


ERC1155: ```_safeTransferFrom(from, to, id, amount, data)```

Also note, ERC1155 compliant contract is capable of implementing non fungible tokens by limiting the supply of a particular tokenId to one. 
