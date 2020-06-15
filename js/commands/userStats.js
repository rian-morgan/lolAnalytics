const ws = require('../kdbWebSockets.js');
module.exports = {
    name: 'mystats',
    description:'Get the user\'s LoL account information.',
    execute (message, args) {
        embedder = function(data) {
            const embed = {
                title:'Last ' + data.games + ' games on ' + args,
                thumbnail:{
                    url: 'http://ddragon.leagueoflegends.com/cdn/10.6.1/img/champion/'+args+'.png',

                },
                fields:[{
                    name:'KDA',
                    value:data.kda[0].toString(),   
                    },
                    {
                        name:'Wins',
                        value:data.win[0].toString(),
                    },
                ],
            };
            return embed
        };

        ws.el(message,embedder);
        //ws.redirectMessage(message);
       // ws.socket.addEventListener('message', function _sendData)
        id = message.member.user.id;
        console.log(id);
        // msg = ".discord.get.summoner.byName[\`" + id + "]";
        msg = ".discord.myStats[\`" + id + ";`"+ args +"]";
        console.log(msg);
        ws.socket.send(msg);
    },
}