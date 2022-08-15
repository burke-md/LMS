import { useState } from "react";
import useInterval from "./hooks/useInterval";
import LineChart from "./components/LineChart";
import fetchTransferLog from "./api/fetchTransferLog";
import fetchBaseFee from "./api/fetchBaseFee";
import fetchGasRatio from "./api/fetchGasRatio";

async function fetchChartData() {
    const newTransferData = await fetchTransferLog();
    const newBaseFeeData = await fetchBaseFee();
    const newGasRatioData = await fetchGasRatio();

    if(newTransferData.blockNumber == newBaseFeeData.blockNumber &&
        newTransferData.blockNumber == newGasRatioData.blockNumber) {
            return {
                blockNumber: newTransferData.blockNumber,
                transactionVolume: newTransferData.numberOfTx,
                baseFee: newBaseFeeData.baseFee,
                gasRatio: newGasRatioData.gasRatio
            }
    } else {
        return -1;
    }
}



export default function OnChainData() {
    let [tetherVolumeLabels, setTetherVolumeLabels] = useState(['0']);
    let [tetherVolumeData, setTetherVolumeData] = useState([0]);

    let [baseFeeLabels, setBaseFeeLabls] = useState(['1', '2', '3', '4']);
    let [baseFeeData, setBaseFeeData] = useState([10, 20, 30, 40]);

    let [gasRatioLabels, setGasRatioLabls] = useState(['1', '2', '3', '4']);
    let [gasRatioData, setGasRatioData] = useState([10, 20, 30, 40]);

    useInterval(async () => {
        const currentBlockNum = tetherVolumeLabels.slice(-1);
        const newData = await fetchChartData();

        if(newData.blockNumber == currentBlockNum ||
            newData.blockNumber == undefined){
            console.log(`invalid block`)
            return; //Do not add new data to state -> continue to poll new data
        }

        setTetherVolumeLabels([...tetherVolumeLabels, newData.blockNumber]);
        setTetherVolumeData([...tetherVolumeData, newData.transactionVolume]);
        
    }, 3000)

    return (
        <>
            <LineChart 
                labelsArray={tetherVolumeLabels}
                dataArray={tetherVolumeData}
                chartName={"Tether Transfer Volume"}
                dataName ={"Number of transfers"} />
        </>
    )
};
