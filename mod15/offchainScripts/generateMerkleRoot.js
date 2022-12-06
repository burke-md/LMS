const { ethers } = require('hardhat');
const { MerkleTree } = require('merkletreejs');
const { keccak256 } = ethers.utils;

// Hardhat testnet signers index 1-3
const addressGroupOne = [
    '0x70997970C51812dc3A010C7d01b50e0d17dc79C8',
    '0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC',
    '0x90F79bf6EB2c4f870365E785982E1f101E93b906',
];
// Hardhat testnet signers index 4-6
const addresssGroupTwo = [
    '0x15d34AAf54267DB7D7c367839AAf71A00a2C6A65',
    '0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc',
    '0x976EA74026E726554dB657fA54763abd0C3a0aa9',
];

async function generate(accountsArr) {
    const padBuffer = (addr) => {                                           
        return Buffer.from(addr.substr(2).padStart(32*2, 0), 'hex')         
    }                                                                       

    const leaves = accountsArr.map(account => padBuffer(account))              
    const tree = new MerkleTree(leaves, keccak256, { sort: true })          
    const merkleRoot = tree.getHexRoot()                                    
                                                                                     
    const proofObj = {};                                                    
                                                                                     
    accountsArr.forEach(function(address) {                                    
        const proof = tree.getHexProof(padBuffer(address));                 
        proofObj[address] = proof;                                          
    });                                                                     
        
    console.log(`\nMerkle root: ${merkleRoot}`);
    console.log(`\nProofs     : ${JSON.stringify(proofObj)}`);
}

generate(addressGroupOne);