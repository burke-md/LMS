import { useState } from "react";
import useInterval from "./hooks/useInterval";
import LineChart from "./components/LineChart";
import fetchTransferLog from "./api/fetchTransferLog";

async function fetchChartData() {
    const newGasRatioData = await fetchTransferLog();
    return {
        blockNumber: newGasRatioData.blockNumber,
        numberOfTx: newGasRatioData.numberOfTx
    }
}

export default function tetherTxChart() {
    let [blockNumbers, setBlockNumbers] = useState(['0']);
    let [tetherTxData, setTetherTxData] = useState([0]);

    useInterval(async () => {
        const currentBlockNum = blockNumbers.slice(-1);
        const newData = await fetchChartData();

        if(newData.blockNumber == currentBlockNum ||
            newData.blockNumber == undefined){
            console.log(`Invalid block`);
            return; //Do not add new data to state -> continue to poll new data
        }

        setBlockNumbers([...blockNumbers, newData.blockNumber]);
        setTetherTxData([...tetherTxData, newData.numberOfTx]);

    }, 3000)

    return (
        <LineChart 
            xAxisElementArray={blockNumbers}
            lineZeroDataArray={tetherTxData}
            chartName={"Tether transfer logs"} 
            lineName={"Number of transfers"}
        />
    )
};
