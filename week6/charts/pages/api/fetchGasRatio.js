import { Alchemy } from "alchemy-sdk";

const alchemy = new Alchemy();

const makeRequest = async function() {
    const res = await alchemy.core
    .getBlock()
    return res;
}
export default async function fetchGasRatio() {
    let result = await makeRequest();

    if(!result) result = await makeRequest();

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


