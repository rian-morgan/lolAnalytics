console.log('Init time: ' + (+ new Date()).toString())

const socket = new WebSocket("ws://localhost:50000");

// Connection opened
socket.addEventListener('open', function (event) {
    console.log('Opened connection to kdb')
    getContext();


});

// declare the chart element as a variable
var ctx = document.getElementById('myChart');
ctx.setAttribute('class','element');
ctx.style.backgroundColor = 'rgba(255,255,255,0.05)';
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
                    //bounds: 'data',

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
      if(data != "'type") {
        myChart.data.datasets.push(data);
        myChart.update();
        };
      socket.removeEventListener('message', _getData, false);
    });
    let sDate = document.querySelector('#sDate').value;
    let eDate = document.querySelector('#eDate').value;
    let req = `.web.get.myStats[\`${context.activeRegion};"${context.activeAccount}";\`${context.activeChampion};\`${e};"${sDate}";"${eDate}"]`;
    console.log(req);
    socket.send(req)

    };

function getContext() {
    console.log('Getting Context');
    socket.addEventListener('message', function _getContext(event) {
        let data = JSON.parse(event.data);
        //console.log(data);
        window.context = data;

        context.accounts.forEach(e=>{
            let menuItem = document.createElement('div');
            menuItem.setAttribute('class','menuItem');
            menuItem.innerHTML = e;
            menuItem.onclick = function() {
                context.activeAccount = e;
                document.getElementById('player-dropdown-btn').innerText = e};
            //console.log(menuItem);
            let playerContent = document.getElementById('player-dropdown-content');
            playerContent.appendChild(menuItem);
            });
        
        context.regions.forEach(e=>{
            let menuItem = document.createElement('div');
            menuItem.setAttribute('class','menuItem');
            menuItem.innerHTML = e;
            menuItem.onclick = function() {
                context.activeRegion = e;
                document.getElementById('region-dropdown-btn').innerText = e};
            //console.log(menuItem);
            let regionContent = document.getElementById('region-dropdown-content');
            regionContent.appendChild(menuItem);
            });
        
        context.champion.forEach(e=>{
            let menuItem = document.createElement('div');
            menuItem.setAttribute('class','menuItem');
            menuItem.innerHTML = e;
            menuItem.onclick = function() {
                context.activeChampion = e;
                document.getElementById('champion-dropdown-btn').innerText = e};
            //console.log(menuItem);
            let championContent = document.getElementById('champion-dropdown-content');
            championContent.appendChild(menuItem);
            });

        socket.removeEventListener('message', _getContext, false);
    });
    socket.send(`makeContext[]`)
};

