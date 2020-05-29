const ws = require('../kdbWebSockets.js')
const Discord = require('discord.js');
module.exports = {
    name: 'champion',
    description: 'Get information on a champion.',
    execute(message, args) {
        //ws.redirectMessage(message);
        /*ws.socket.addEventListener('message', function _sendData(event) {
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
            ws.socket.removeEventListener('message', _sendData, true);
        }); */
        embedder = function(data) {
            const embed = {
            title:data.name + ', ' + data.title,
            thumbnail:{url: 'http://ddragon.leagueoflegends.com/cdn/10.6.1/img/champion/'+args+'.png'},
            fields:[{
                name:'Synopsis',
                value:data.lore
            },
            ]
            };
            return embed
        };
        ws.el(message, embedder)
        ws.socket.send(`.champion.meta \`${args}`);
    },
}