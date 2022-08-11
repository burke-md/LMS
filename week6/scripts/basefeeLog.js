import { Alchemy, Network } from "alchemy-sdk";
import { ethers } from "ethers";

const alchemy = new Alchemy();

async function main() {
    const result = await alchemy.core
        .getBlock()

    const data = {
        blockNumber: result.number, 
        baseFee: Number(result.baseFeePerGas.toString())
    }

    return data;
};


const blockStats = await main();
console.log(blockStats);
