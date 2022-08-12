import { Alchemy, Network } from "alchemy-sdk";

const alchemy = new Alchemy();

export default async function fetchBaseFee() {
    const result = await alchemy.core
        .getBlock()

    const data = {
        blockNumber: result.number, 
        baseFee: Number(result.baseFeePerGas.toString())
    }

    return data;
};

