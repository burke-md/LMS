import React from "react";
import LineChart from "./components/LineChart";

export default function OnChainData() {
    const labelsArray = ['1', '2', '3', '4'];
    const dataArray = [10, 20, 30, 40];
    const chartName = "Gas Ratio";

    return (
        <>
            <LineChart 
                labelsArray={labelsArray}
                dataArray={dataArray}
                chartName={"Tether Transfer Volume"} />

            <LineChart 
                labelsArray={labelsArray}
                dataArray={dataArray}
                chartName={"Base Fee"} />

            <LineChart 
                labelsArray={labelsArray}
                dataArray={dataArray}
                chartName={"Gas Ratio"} />
        </>
    )
};
