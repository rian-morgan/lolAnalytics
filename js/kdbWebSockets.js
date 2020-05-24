// require websockets
const WebSocket = require('ws');

// Create WebSocket connection.
const socket = new WebSocket('ws://localhost:5000');

// Connection opened
socket.addEventListener('open', function (event) {
    //socket.send('Open Socket to kdb');
    console.log('Opened connection to kdb')
});

// Listen for messages
socket.addEventListener('message', function (event) {
    console.log('Message from server:\n' + event.data);
});


// this function is used to setup an event listener and redirect the kdb response to bot
function redirectMessage(message) {
    socket.addEventListener('message', function _sendData(event) {
        //data = (event.data);
        data = JSON.parse(event.data);
        console.log(data);
        message.channel.send({embed: JSON.parse(event.data)});
        socket.removeEventListener('message', _sendData, true);
    });
};

function el(message,embedder) {
    socket.addEventListener('message', function _sendData(event) {
        //data = (event.data);
        data = JSON.parse(event.data);
        console.log(data);
        embeddedMsg = embedder(data);
        console.log(embeddedMsg);
        message.channel.send({embed: embeddedMsg});
        socket.removeEventListener('message', _sendData, true);
    });  
}

exports.socket = socket;
exports.redirectMessage = redirectMessage;
exports.el = el;

