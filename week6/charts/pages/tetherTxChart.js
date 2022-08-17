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

        if(xAxisLength < 1) {
            targetBlock = null;
        }

        if(xAxisLength > 0 && xAxisLength < 4) {
            targetBlock = Number(blockNumbers[0]) - 1;
        }

        if(xAxisLength > 3) {
            targetBlock = Number(blockNumbers.slice(-1)) + 1;
        }        

        const newData = await fetchTransferLog(targetBlock);

        if(!newData){
            console.log(`Invalid response.`);
            return; //Do not add new data to state -> continue to poll new data
        }

        let cleanedBlockNumbersArr;
        let cleanedTxDataArr;

        if(xAxisLength === 0) {
            cleanedBlockNumbersArr = [newData.blockNumber];
            cleanedTxDataArr = [newData.numberOfTx];
        }

        if(xAxisLength > 0 && xAxisLength < 4) {
            cleanedBlockNumbersArr = [newData.blockNumber, ...blockNumbers];  
            cleanedTxDataArr = [newData.numberOfTx, ...txData];
        }

        if(xAxisLength > 3) {
            cleanedBlockNumbersArr = [...blockNumbers, newData.blockNumber];
            cleanedTxDataArr = [...txData, newData.numberOfTx];
        }
 
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
