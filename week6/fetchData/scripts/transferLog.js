import { Alchemy, Network } from "alchemy-sdk";
import { ethers } from "ethers";

const alchemy = new Alchemy();

async function main() {
    const result = await alchemy.core
        .getLogs({
            address: "0xdAC17F958D2ee523a2206206994597C13D831ec7",
            topics: [
                ethers.utils.id("Transfer(address,address,uint256)")
            ]
        });
    
    const data = {
        blockNumber: result[0].blockNumber,
        numberOfTx: result.length
    }

    return data;
};


const blockStats = await main();
console.log(blockStats);

