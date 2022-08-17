import { useState } from "react";
import useInterval from "./hooks/useInterval";
import LineChart from "./components/LineChart";
import fetchGasRatio from "./api/fetchGasRatio";

export default function gasRatioChart() {
    let [blockNumbers, setBlockNumbers] = useState([]);
    let [gasRatioData, setGasRatioData] = useState([]);

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

        const newData = await fetchGasRatio(targetBlock);

        if(!newData){
            console.log(`Invalid response.`);
            return; //Do not add new data to state -> continue to poll new data
        }

        let cleanedBlockNumbersArr;
        let cleanedGasRatioDataArr;

        if(xAxisLength === 0) {
            cleanedBlockNumbersArr = [newData.blockNumber];
            cleanedGasRatioDataArr = [newData.gasRatio];
        }

        if(xAxisLength > 0 && xAxisLength < 4) {
            cleanedBlockNumbersArr = [newData.blockNumber, ...blockNumbers];  
            cleanedGasRatioDataArr = [newData.gasRatio, ...gasRatioData];
        }

        if(xAxisLength > 3) {
            cleanedBlockNumbersArr = [...blockNumbers, newData.blockNumber];
            cleanedGasRatioDataArr = [...gasRatioData, newData.gasRatio];
        }
  
        setBlockNumbers([...cleanedBlockNumbersArr]);
        setGasRatioData([...cleanedGasRatioDataArr]);
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
