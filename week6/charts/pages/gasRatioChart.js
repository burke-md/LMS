import { useState } from "react";
import useInterval from "./hooks/useInterval";
import LineChart from "./components/LineChart";
import fetchGasRatio from "./api/fetchGasRatio";

async function fetchChartData() {
    const newGasRatioData = await fetchGasRatio();

    return {
        blockNumber: newGasRatioData.blockNumber,
        gasRatio: newGasRatioData.gasRatio
    }
}

export default function gasRatioChart() {
    let [blockNumbers, setBlockNumbers] = useState(['0']);
    let [gasRatioData, setGasRatioData] = useState([0]);

    useInterval(async () => {
        const currentBlockNum = blockNumbers.slice(-1);
        const newData = await fetchChartData();

        if(newData.blockNumber == currentBlockNum ||
            newData.blockNumber == undefined){
            console.log(`Invalid block`);
            return; //Do not add new data to state -> continue to poll new data
        }

        setBlockNumbers([...blockNumbers, newData.blockNumber]);
        setGasRatioData([...gasRatioData, newData.gasRatio]);

    }, 3000)

    return (
        <LineChart 
            xAxisElementArray={blockNumbers}
            lineZeroDataArray={gasRatioData}
            chartName={"Gas Ratio"} 
            lineName={"gasUsed / gasLimit (percentage)"}
        />
    )
};
