const wst = require('../kdbWebSockets.js')
const Discord = require('discord.js');
module.exports = {
    name: 'champion',
    description: 'Get information on a champion.',
    execute(message, args) {
        //ws.redirectMessage(message);
        wst.socket.addEventListener('message', function _sendData(event) {
            //data = (event.data);
            let data = JSON.parse(event.data);
            embedder = {
                title:data.name, 
                fields:[{
                    name:'Synopsis',
                    value:data.blurb
                },
                ]
                };
            console.log(embedder);
            //message.channel.send({embed: JSON.parse(event.data)});
            message.channel.send({embed: embedder});
            wst.socket.removeEventListener('message', _sendData, true);
        });
        wst.socket.send(`.champion.meta \`${args}`);
    },
}