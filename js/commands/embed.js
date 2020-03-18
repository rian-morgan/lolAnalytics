const Discord = require('discord.js');
module.exports = {
    name:'embedder',
    execute (message, args) {
        embedMsg = {
            title: "hi",
            fields:[{
                name:'field1',
                value:'this is some text.'
            }]
        }
        message.channel.send({embed: embedMsg})
    },
}