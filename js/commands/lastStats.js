const ws = require('../kdbWebSockets.js');
module.exports = {
    name: 'laststats',
    description:'Get the user\'s LoL account information.',
    execute (message, args) {
        embedder = function(data) {
            const embed = {
                title:'Last games played on ' + data.championId.toString(),
                thumbnail:{
                    url: 'http://ddragon.leagueoflegends.com/cdn/10.6.1/img/champion/'+data.championId.toString()+'.png',

                },
                fields:[{
                        name:'KDA',
                        value:data.kda[0].toString(),   
                    },
                    {
                        name:'KDA1',
                        value:data.kda1,  // nb this is already passed from kdb as a string (anything else is an object) 
                    },
                    {
                        name:'Result',
                        value:data.result[0].toString(),
                    },
                    {
                        name:'CS',
                        value:data.cs[0].toString(),
                    },
                    {
                        name:'VS',
                        value:data.visionScore[0].toString(),
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
        msg = ".discord.myLastMatch[\`" + id + ";`"+ args +"]";
        console.log(msg);
        ws.socket.send(msg);
    },
}