import { useState } from "react";
import LineChart from "./components/LineChart";

export default function OnChainData() {
    const [tetherVolumeLabels, setTetherVolumeLabls] = useState(['1', '2', '3', '4']);
    const [tetherVolumeData, setTetherVolumeData] = useState([10, 20, 30, 40]);

    const [baseFeeLabels, setBaseFeeLabls] = useState(['1', '2', '3', '4']);
    const [baseFeeData, setBaseFeeData] = useState([10, 20, 30, 40]);

    const [gasRatioLabels, setGasRatioLabls] = useState(['1', '2', '3', '4']);
    const [gasRatioData, setGasRatioData] = useState([10, 20, 30, 40]);

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
