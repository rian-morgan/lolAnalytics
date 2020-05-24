const ws = require('../kdbWebSockets.js');
module.exports = {
    name: 'mystats',
    description:'Get the user\'s LoL account information.',
    execute (message, args) {
        ws.redirectMessage(message);
       // ws.socket.addEventListener('message', function _sendData)
        id = message.member.user.id;
        console.log(id);
        msg = ".discord.get.summoner.byName[\`" + id + "]";
        console.log(msg);
        ws.socket.send(msg);
    },
}