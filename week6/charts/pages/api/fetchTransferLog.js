import { Alchemy } from "alchemy-sdk";
import { ethers } from "ethers";

const alchemy = new Alchemy();

const makeRequest = async function(blockNum) {
    let res = null;
    try {
        res = await alchemy.core
        .getLogs({
            address: "0xdAC17F958D2ee523a2206206994597C13D831ec7",
            //Where setting to & from to same value returns one block's data
            //& passing in null values returns current block.
            fromBlock: blockNum,
            toBlock: blockNum,
            topics: [
                ethers.utils.id("Transfer(address,address,uint256)")
            ]
        });
    } catch (err) {
        console.log(`===\ngetLogs w/ blockNum: ${blockNum} has thrown the following error: \n ${err}`);
    }
    return res;
}

export default async function fetchTransferLog(blockNum) {
    const result = await makeRequest(blockNum);
    if(result == null ||
        result == undefined) {
        return null;
    }

    if(result[0] !== undefined) {
        const data = {
            blockNumber: result[0].blockNumber,
            numberOfTx: result.length
        }
        return data;
    }
    
    return null;
}


    
