import { Alchemy } from "alchemy-sdk";

const alchemy = new Alchemy();

export default async function fetchGasRatio() {

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


