const ws = require('../kdbWebSockets.js')
module.exports = {
	name: 'me',
	description: 'Set user\'s LoL account and region.',
	execute(message, args) {
        id = message.member.user.id;
        if (args.length < 2){
            return message.channel.send(`You didn't provide a LoL account username and/or region, ${message.author}!\n Please format like:\n !me <lol account name> <region>`);
        } else {
            lolAcc = `${args[0]}`;
            lolRegion = `${args[1]}`;
            // return acc/region to user
            message.channel.send(`Lol Account: ${lolAcc}\nLoL Region: ${lolRegion}`)
            msg = `.discord.setAccountMx[\`$"${id}\";\"${lolAcc}\";\`${lolRegion}]`
            console.log(msg)
            ws.socket.send(msg)
        } 
	},
}