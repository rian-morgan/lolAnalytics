const ws = require('../kdbWebSockets.js')
const Discord = require('discord.js');
module.exports = {
    name: 'champion',
    description: 'Get information on a champion.',
    execute(message, args) {
        embedder = function(data) {
            const embed = {
                title:data.name + ', ' + data.title,
                thumbnail:{
                    url: 'http://ddragon.leagueoflegends.com/cdn/10.6.1/img/champion/'+args+'.png',
                },
                fields:[{
                    name:'Synopsis',
                    value:data.lore,
                    },
                ],
                image: {
                    url: 'http://ddragon.leagueoflegends.com/cdn/10.6.1/img/champion/'+args+'.png',
                },
                image: {
                    url: 'http://ddragon.leagueoflegends.com/cdn/10.6.1/img/champion/'+args+'.png',
                },
            };
            return embed
        };
        ws.el(message, embedder)
        ws.socket.send(`.champion.meta \`${args}`);
    },
}