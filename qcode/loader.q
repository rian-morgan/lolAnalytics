// --- getLolStats q load script
// utils.q must be l9oaded first, this fiel should not cause any dependencies, intended to be used for other projects, a resource for basic fucntionality

// ENV variables
`RITOQ setenv "C:\\RiotApi\\qcode";
`RITOJS setenv "C:\\RiotApi\\js";
`RITODATA setenv "C:\\RiotApi\\data";
`RITOBIN setenv "C:\\RiotApi\\bin";

//load order: utils.q, riotApi.q, lolMetaData.q
system'["l ",/:getenv[`RITOQ],/:("\\utils.q";"\\riotApi.q";"\\lolMetaData.q")];
