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

const data = {
    labels: ['1', '2', '3'],
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
            data: [10, 20, 30]
        }
    ]
};

export default function LineChart() {
    return (
        <>
            <h2> Chart ex </h2>
            <Line 
                data={data}
                width={400}
                height={400}
            />
        </>
    )
};
