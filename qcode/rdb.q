// --- getLolStats q load script
// utils.q must be l9oaded first, this fiel should not cause any dependencies, intended to be used for other projects, a resource for basic fucntionality

// ENV variables
//`RITOQ setenv "C:\\lolDiscordBot\\qcode";
//`RITOJS setenv "C:\\lolDiscordBot\\js";
//`RITODATA setenv "C:\\lolDiscordBot\\data";
//`RITOBIN setenv "C:\\lolDiscordBot\\bin";

//load order: utils.q, riotApi.q, lolMetaData.q
//system'["l ",/:getenv[`RITOQ],/:("\\riot.utils.q";"\\riot.api.q";"\\riot.metaData.q")];

//load in common files to each process
/loadOrder:first("**";",")0:`:config/loadOrder.csv;
/system'["l ",/:(getenv[`RITOQ],"/"),/:loadOrder];

// testing require lib
system"l ",getenv[`KDBSRC],"/require.q"
.require.init[];
.require.lib `log;
.require.lib `riot.utils;
.require.lib `riot.api;
.require.lib `riot.metaData;
.require.lib `match.schema;
.require.lib `riot.analytics;


// LoL account data for discord users
.discord.loadAccountMx[];

// load champion metadata
.champion.metaLoad[];