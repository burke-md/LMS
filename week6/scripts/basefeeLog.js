import { Alchemy, Network } from "alchemy-sdk";
import { ethers } from "ethers";

const alchemy = new Alchemy();

async function main() {
    const result = await alchemy.core
        .getBlock()
   /* 
    const data = {
        blockNumber: result[0].blockNumber,
        numberOfTx: result.length
    }

    return data;
    */
    return result.baseFeePerGas.toString();
};


const blockStats = await main();
console.log(blockStats);
