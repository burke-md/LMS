import { Alchemy } from "alchemy-sdk";
import { ethers } from "ethers";

const alchemy = new Alchemy();

const makeRequest = async function() {
    const res = await alchemy.core
        .getLogs({
            address: "0xdAC17F958D2ee523a2206206994597C13D831ec7",
            topics: [
                ethers.utils.id("Transfer(address,address,uint256)")
            ]
        });
    return res;
}

export default async function fetchTransferLog() {
    let result = await makeRequest();

    if(result[0] == undefined) {
        console.log(`bad result`)
        return -1;
    }

    const data = {
        blockNumber: result[0].blockNumber,
        numberOfTx: result.length
    }
    return data;
}


    
