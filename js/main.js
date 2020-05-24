// require .env file containing all env vars
require('dotenv').config();

// start websocket to kdb process
const ws = require('./kdbWebSockets.js');

// require the discord.js module and Node file system module
const fs = require('fs');
const Discord = require('discord.js');
// require discord client config file
const { prefix, token } = require('./config.json');

// create a new Discord client and add commands from commands folder
const client = new Discord.Client();
client.commands = new Discord.Collection();
const commandFiles = fs.readdirSync('./commands').filter(file => file.endsWith('.js'));

// loop over files in commandFiles and dynamically set commands to collection
for (const file of commandFiles) {
	const command = require(`./commands/${file}`);

	// set a new item in the Collection
	// with the key as the command name and the value as the exported module
	client.commands.set(command.name, command);
}

// when the client is ready, run this code
// this event will only trigger one time after logging in
client.on('ready', () => {
    console.info(`Logged in as ${client.user.tag}!`);
  });

client.on('message', message => {
    console.log(message.content);
    if (!message.content.startsWith(prefix) || message.author.bot) return;
    const args = message.content.slice(prefix.length).split(' ');
    const command = args.shift().toLowerCase();

    if (!client.commands.has(command)) return;

    try {
	    client.commands.get(command).execute(message, args);
    } catch (error) {
        console.error(error);
        message.reply('there was an error trying to execute that command!');
    }
});

// Get client's auth token from .env and login to to Discord
const TOKEN = process.env.TOKEN;
client.login(TOKEN);