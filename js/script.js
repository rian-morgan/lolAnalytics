console.log('Init time: ' + (+ new Date()).toString())

const socket = new WebSocket("ws://localhost:50000");

// Connection opened
socket.addEventListener('open', function (event) {
    console.log('Opened connection to kdb')
});

// Listen for messages
/*socket.addEventListener('message', function (event) {
    console.log('Message from server:\n' + event.data);
    console.log(typeof event.data);
    console.log(JSON.parse(event.data));
    //mydata1.datasets[0].data = JSON.parse(event.data)
    window.dt = JSON.parse(event.data)
    return (JSON.parse(event.data))
});*/


// declare the chart element as a variable
var ctx = document.getElementById('myChart');

myChart = new Chart(ctx, {
    type: 'line',
    data: {
        //labels:[],
        datasets:[]
        },
    options: {
        scales: {
            yAxes: [{
                stacked: false,
                position: 'right',
                ticks: {
                    suggestedMin: 0,
                    suggestedMax: 1
                }
            }],
            xAxes: [{
                display: true,
                type:'time',
                time: {
                    unit: 'day'
                },
                ticks:{
                    source: 'data'
                },
            }]
        }
    }
  });


// create a new chart and set it as the var myChart
var timeFormat = 'MM/DD/YYYY HH:mm';

function newDate(days) {
    return moment().add(days, 'd').toDate();
}

function newDateString(days) {
    return moment().add(days, 'd').format(timeFormat);
}

var color = Chart.helpers.color;
function randomScalingFactor(x=10) {return x*Math.random()};


function getData(e) {
    console.log('adding data')
    socket.addEventListener('message', function _getData(event) {
      let data = JSON.parse(event.data);
      console.log(data)
      myChart.data.datasets.push(data);
      myChart.update();
      socket.removeEventListener('message', _getData, false);
    });
    socket.send(`.web.getMyStats[\`${e}]`)

    };