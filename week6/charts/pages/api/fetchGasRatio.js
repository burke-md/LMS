import { Alchemy } from "alchemy-sdk";

const alchemy = new Alchemy();

const makeRequest = async function(blockNum) {
    let res;
    try {
        res = await alchemy.core
    .getBlock(blockNum)
    } catch (err) {
        console.log(`===\ngetBlock (gasRatio) w/ blockNum: ${blockNum} has thrown the following error: \n ${err}`);
    }

    return res;
}
export default async function fetchGasRatio(blockNum) {
    let result = await makeRequest(blockNum);

    if(result == null || result == undefined) return null;
    
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