// --- getLolStats q load script
// utils.q must be l9oaded first, this fiel should not cause any dependencies, intended to be used for other projects, a resource for basic fucntionality

// ENV variables
`RITOQ setenv "C:\\lolDiscordBot\\qcode";
`RITOJS setenv "C:\\lolDiscordBot\\js";
`RITODATA setenv "C:\\lolDiscordBot\\data";
`RITOBIN setenv "C:\\lolDiscordBot\\bin";

//load order: utils.q, riotApi.q, lolMetaData.q
system'["l ",/:getenv[`RITOQ],/:("\\utils.q";"\\riotApi.q";"\\lolMetaData.q")];
