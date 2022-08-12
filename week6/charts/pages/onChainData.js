import { useState } from "react";
import LineChart from "./components/LineChart";
import fetchTransferLog from "./api/fetchTransferLog";
import fetchBaseFee from "./api/fetchBaseFee";
import fetchGasRatio from "./api/fetchGasRatio";

async function updateChartData(
    tetherVolumeLabelsSetter,
    tetherVolumeDataSetter,
    baseFeeLablsSetter,
    baseFeeDataSetter,
    gasRatioLablsSetter,
    gasRatioDataSetter
) {
    const x = await fetchTransferLog();
    const y = await fetchBaseFee();
    const z = await fetchGasRatio();

    console.log(`t log : ${JSON.stringify(x)}`);
    console.log(`basefee : ${JSON.stringify(y)}`);
    console.log(`g ratio : ${JSON.stringify(z)}`);
//Conditionally set - every set perpetuates re-render cycle
    tetherVolumeLabelsSetter(['2', '3', '4', '5'])
}
export default function OnChainData() {
    const [tetherVolumeLabels, setTetherVolumeLabels] = useState(['1', '2', '3', '4']);
    const [tetherVolumeData, setTetherVolumeData] = useState([10, 20, 30, 40]);

    const [baseFeeLabels, setBaseFeeLabls] = useState(['1', '2', '3', '4']);
    const [baseFeeData, setBaseFeeData] = useState([10, 20, 30, 40]);

    const [gasRatioLabels, setGasRatioLabls] = useState(['1', '2', '3', '4']);
    const [gasRatioData, setGasRatioData] = useState([10, 20, 30, 40]);

    //Pass state setter funcs to outside reqs handler - to be conditionally set on change to 
    // force re-render.
    updateChartData(
        setTetherVolumeLabels,
        setTetherVolumeData,
        setBaseFeeLabls,
        setBaseFeeData,
        setGasRatioLabls,
        setGasRatioData
    );
 
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
