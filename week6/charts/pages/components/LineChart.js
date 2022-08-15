import { Line } from 'react-chartjs-2';
import {
    Chart as ChartJS,
    CategoryScale,
    LinearScale,
    PointElement,
    LineElement,
    Title,
    Tooltip,
    Legend,
} from 'chart.js';

ChartJS.register(
    CategoryScale,
    LinearScale,
    PointElement,
    LineElement,
    Title,
    Tooltip,
    Legend
);

const config = {
    labels: ['0'],
    datasets: [
        {
            label: "Chart1",
            fill: false,
            lineTension: 0.1,
            backgroundColor: 'rgb(75,192,192,0.4)',
            borderColor: 'rgba(75,192,192,1)',
            borderCapStyle: 'butt',
            borderDash: [],
            borderDashOffset: 0.0,
            borderJoinStyle: 'miter',
            pointBoarderColor: 'rgba(75,192,192,1)',
            pointBackgroundColor: '#fff',
            pointBorderWidth: 1,
            pointHoverRadius: 5,
            pointHoverBackgroundColor: 'rba(75,192,192,1)',
            pointHoverBorderColor: 'rgba(75,192,192,1)',
            pointHoverBorderWidth: 2,
            pointRadius: 1,
            pointHitRadius: 10,
            data: [0]
        }
    ]
};

export default function LineChart({ labelsArray, dataArray, chartName, dataName }) {
    const currentData = {
        ...config,
    };

    currentData.labels = labelsArray; //Awkward syntax - fix this
    currentData.datasets[0].data = dataArray; 
    currentData.datasets[0].label = dataName;

    console.log(`labels len : ${currentData.labels.length}`)
    console.log(`config data len : ${currentData.datasets[0].data.length}`)

    return (
        <>
            <h2> {chartName} </h2>
            <Line  data={currentData} />
        </>
    )
};