import { useState } from "react";
import useInterval from "./hooks/useInterval";
import LineChart from "./components/LineChart";
import fetchTransferLog from "./api/fetchTransferLog";

export default function tetherTxChart() {
    let [blockNumbers, setBlockNumbers] = useState([]);
    let [txData, setTxData] = useState([]);

    useInterval(async () => {
        const xAxisLength = blockNumbers.length;
        let targetBlock;
        // three stages:
        // X first render
        // less than ten
        // greater than ten

        if(xAxisLength < 1) {
            targetBlock = null;
        }

        if(xAxisLength >= 1 && xAxisLength <= 10) {
            //
            let z = blockNumbers;
            let x = blockNumbers[0];
            console.log(`xAxis length: ${xAxisLength}`)
            console.log(`full block num array: ${z}`)
            console.log(`first index: ${x}`)
            //
            targetBlock = Number(blockNumbers[0]) - 1;
            console.log(`target block: ${targetBlock}`)
        }

        if(xAxisLength > 10) {
            targetBlock = Number(blockNumbers.slice(-1)) + 1;
            console.log(`target block: ${targetBlock}`)
        }        

        const newData = await fetchTransferLog(targetBlock);

        //Clean data

        if(!newData){
            console.log(`Invalid response.`);
            return; //Do not add new data to state -> continue to poll new data
        }

        //TODO make check for repeat data??

        let cleanedBlockNumbersArr;
        let cleanedTxDataArr;

        if(xAxisLength === 0) {
            cleanedBlockNumbersArr = [newData.blockNumber];
            cleanedTxDataArr = [newData.numberOfTx];
        }

        if(xAxisLength > 0 && xAxisLength < 11) {
            cleanedBlockNumbersArr = [newData.blockNumber, ...blockNumbers];  
            cleanedTxDataArr = [newData.numberOfTx, ...txData];
        }

        if(xAxisLength > 10) {
            cleanedBlockNumbersArr = [...blockNumbers, newData.blockNumber];
            cleanedTxDataArr = [...txData, newData.numberOfTx];
        }

        console.log(`right before setting state`);
        console.log(`BN.len: ${cleanedBlockNumbersArr.length}`);
        console.log(`TX.len: ${cleanedTxDataArr.length}`);
        console.log(`===`)

        setBlockNumbers([...cleanedBlockNumbersArr]);
        setTxData([...cleanedTxDataArr]);
    }, 3000)



    return (
        <LineChart 
            xAxisElementArray={blockNumbers}
            lineZeroDataArray={txData}
            chartName={"Tether transfer logs"} 
            lineName={"Number of transfers"}
        />
    )
};
