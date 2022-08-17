import { useState } from "react";
import useInterval from "./hooks/useInterval";
import LineChart from "./components/LineChart";
import fetchBaseFee from "./api/fetchBaseFee";

export default function OnChainData() {
    let [blockNumbers, setBlockNumbers] = useState([]);
    let [baseFeeData, setBaseFeeData] = useState([]);

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

        const newData = await fetchBaseFee(targetBlock);

        if(!newData){
            console.log(`Invalid response.`);
            return; //Do not add new data to state -> continue to poll new data
        }

        let cleanedBlockNumbersArr;
        let cleanedGasRatioDataArr;

        if(xAxisLength === 0) {
            cleanedBlockNumbersArr = [newData.blockNumber];
            cleanedGasRatioDataArr = [newData.baseFee];
        }

        if(xAxisLength > 0 && xAxisLength < 4) {
            cleanedBlockNumbersArr = [newData.blockNumber, ...blockNumbers];  
            cleanedGasRatioDataArr = [newData.baseFee, ...baseFeeData];
        }

        if(xAxisLength > 3) {
            cleanedBlockNumbersArr = [...blockNumbers, newData.blockNumber];
            cleanedGasRatioDataArr = [...baseFeeData, newData.baseFee];
        }
  
        setBlockNumbers([...cleanedBlockNumbersArr]);
        setBaseFeeData([...cleanedGasRatioDataArr]);
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
