# Advanced Nft

This project will fulfill the following criteria:

- [x] The nft will not be free
- [ ] The nft address will have at least 6 leading zeros
- [x] Users will be able to mint one token based on a merkle tree access list(mapping)
    - [x] Bench mark the merkle tree w/ bool mapping quantity limitation
- [ ] Users will be able to mint one token based on a merkle tree access list(bitmap)
    - [ ] Bench merk the merkle tree w/ bitmapping quantity limitation
- [ ] Contracts will be prevented from minting (minter must be EOA)
- [ ] Use commit/reveal pattern w/ 10 block lockout period for token IDs
- [ ] Implement delegateMulticall
- [ ] Nft should have a state (presale, public sale, max supply has been reached)
- [ ] Users should be able to assign string value to nft (max length 20 chars) 
- [ ] Contract should be owned by a muiltisig Gnosis Sage
- [x] Nft must have corosponding 1155 wrapper 
- [ ] 1155 must be transferable and exchangeable for corrosponding 721 nft
