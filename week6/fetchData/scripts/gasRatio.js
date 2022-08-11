import { Alchemy, Network } from "alchemy-sdk";
import { ethers } from "ethers";

const alchemy = new Alchemy();

async function main() {
    const result = await alchemy.core
        .getBlock()

    const blockNumber = result.number; 
    const gasUsed = result.gasUsed; 
    const gasLimit = result.gasLimit;

    const gasRatio = gasUsed / gasLimit * 100;

    const data = {
        blockNumber,
        gasRatio
    }

    return data;
};


const blockStats = await main();
console.log(blockStats);
