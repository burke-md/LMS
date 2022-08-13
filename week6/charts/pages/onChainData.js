import { useState } from "react";
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
    let [tetherVolumeLabels, setTetherVolumeLabels] = useState(['1', '2', '3', '4']);
    let [tetherVolumeData, setTetherVolumeData] = useState([10, 20, 30, 40]);

    let [baseFeeLabels, setBaseFeeLabls] = useState(['1', '2', '3', '4']);
    let [baseFeeData, setBaseFeeData] = useState([10, 20, 30, 40]);

    let [gasRatioLabels, setGasRatioLabls] = useState(['1', '2', '3', '4']);
    let [gasRatioData, setGasRatioData] = useState([10, 20, 30, 40]);

 
    const updateData = async function(){
        const newData = await fetchChartData();
        console.log(`newData: ${JSON.stringify(newData)}`)

        if (!newData) console.log(`API has returned invalid data.`);

        setTetherVolumeLabels([...tetherVolumeLabels, newData.blockNumber]);
        //setBaseFeeLabls = [...baseFeeLabels, newData.blockNumber];
        //setGasRatioLabls = [...gasRatioLabels, newData.blockNumber];
    
        setTetherVolumeData([...tetherVolumeData, newData.transactionVolume]);
        //setBaseFeeData = [...baseFeeData, newData.baseFee];
        //setGasRatioData = [...gasRatioData, newData.gasRatio];

    } 

    updateData();
    
    return (
        <>
            <LineChart 
                labelsArray={tetherVolumeLabels}
                dataArray={tetherVolumeData}
                chartName={"Tether Transfer Volume"} />

            <LineChart 
                labelsArray={baseFeeLabels}
                dataArray={baseFeeData}
                chartName={"Base Fee"} />

            <LineChart 
                labelsArray={gasRatioLabels}
                dataArray={gasRatioData}
                chartName={"Gas Ratio"} />
        </>
    )
};
