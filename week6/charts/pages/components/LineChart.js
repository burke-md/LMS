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
    labels: [],
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
            data: []
        }
    ]
};

export default function LineChart() {
    const dataArray = [10, 10, 10];
    const labelsArray = ['1', '2', '3'];
    const currentData = {...data};
    return (
        <>
            <h2> Chart ex </h2>
            <Line 
                data={currentData}
                width="2000px"
                height="2000px"
                options={{ maintainAspectRatio: false }}
            />
        </>
    )
};
