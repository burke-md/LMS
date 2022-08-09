import { Alchemy, Network } from "alchemy-sdk";
import { ethers } from "ethers";

const alchemy = new Alchemy();
const filter = {
    address: "0xdAC17F958D2ee523a2206206994597C13D831ec7",
    topics: [
        ethers.utils.id("Transfer(address,address,uint256)")
    ]
}

alchemy.ws.on(filter, (log, event)  => {
    console.log(`log: ${JSON.stringify(log)}`);
});


