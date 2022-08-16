import { Alchemy } from "alchemy-sdk";

const alchemy = new Alchemy();

const makeRequest = async function() {
    const res = await alchemy.core
    .getBlock();
    return res;
}
export default async function fetchBaseFee() {
    let result = await makeRequest();

    if(!result) result = await makeRequest();

    const data = {
        blockNumber: result ? result.number: -1, 
        baseFee: Number(result.baseFeePerGas.toString())
    }
    return data;
};

