import { Alchemy } from "alchemy-sdk";

const alchemy = new Alchemy();

const makeRequest = async function(blockNum) {
    let res;
    try{
        res = await alchemy.core
        .getBlock(blockNum)
    } catch (err) {
        console.log(`===\ngetBlock (baseFee) w/ blockNum: ${blockNum} has thrown the following error: \n ${err}`);
    }
    return res;
}
export default async function fetchBaseFee(blockNum) {
    let result = await makeRequest(blockNum);

    if(result == null || result == undefined) return null;
    
    const data = {
        blockNumber: result.number, 
        baseFee: result.baseFeePerGas
    }
    return data;
};