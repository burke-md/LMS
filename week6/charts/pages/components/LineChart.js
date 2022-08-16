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

export default function LineChart({ xAxisElementArray, lineZeroDataArray, chartName, lineName }) {
    const currentData = {
        labels: xAxisElementArray,
        datasets: [
            {
                label: lineName,
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
                data: lineZeroDataArray
            }
        ]
    };

    return (
        <>
            <h2> {chartName} </h2>
            <Line  data={currentData} />
        </>
    )
};