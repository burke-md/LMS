# ERC721Pausable & ERC721URIStorage


ERC721URIStorage provides a mapping (_tokenURIs) to associate a string (the URI) with a uint256 (the token Id). It also provides a function that returns a complete URI by appending the tokenID to the _baseURI variable.


ERC721Pausable provides a means to prevent transfers, minting and burning. It does this by overriding the _beforeTransfer hook and using a require statement. 
One risk associated with using this pause functionality is the centralization involved. If a contract is paused and then access to the controlling address is lost, all funds to tokens could be trapped. 