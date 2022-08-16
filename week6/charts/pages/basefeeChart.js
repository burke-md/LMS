import { useState } from "react";
import useInterval from "./hooks/useInterval";
import LineChart from "./components/LineChart";
import fetchBaseFee from "./api/fetchBaseFee";

async function fetchChartData() {
    const newBaseFeeData = await fetchBaseFee();
    return {
        blockNumber: newBaseFeeData.blockNumber,
        baseFee: newBaseFeeData.baseFee
    }
}

export default function OnChainData() {
    let [blockNumbers, setBlockNumbers] = useState(['0']);
    let [baseFeeData, setBaseFeeData] = useState([0]);

    useInterval(async () => {
        const currentBlockNum = blockNumbers.slice(-1);
        const newData = await fetchChartData();

        if(newData.blockNumber == currentBlockNum ||
            newData.blockNumber == undefined){
            console.log(`Invalid block`);
            return; //Do not add new data to state -> continue to poll new data
        }

        setBlockNumbers([...blockNumbers, newData.blockNumber]);
        setBaseFeeData([...baseFeeData, newData.baseFee]);

    }, 3000)

    return (
        <LineChart 
            xAxisElementArray={blockNumbers}
            lineZeroDataArray={baseFeeData}
            chartName={"Basefee"} 
            lineName={"Basefeee (wei)"}
        />
    )
};
