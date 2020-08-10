// Dictionary of command line args passes to process
.proc.args:raze each .Q.opt .z.x;
.proc.manifest:("SSSSSS";enlist",")0:hsym `$getenv[`RITOCONFIG],"/processes.csv";

// utility functins serving kdb processes pulling data from riot api

.ws.active:([] handle:(); connectTime:());
.ws.queries:([]handle:();queryTime:();func:();res:());


//.z.wo:{`.ws.active upsert (x;.z.t)}
//.z.wc:{delete from `.ws.active where handle =x};
.z.wo:{.log.info["Connection ",string[x]," from ",sv[".";string "i"$0x0 vs .z.a]," opened"];`.ws.active upsert (x;.z.t)};
.z.wc:{.log.info["Connection ",string[x]," closed"];delete from `.ws.active where handle =x};
//.z.ws:{neg[.z.w].Q.s value x};
.z.ws:{.log.info[x]; k:.j.j @[value;x;{`$ "'",x}];.log.info[k];`.ws.queries upsert (.z.w;.z.t;x;k);neg[.z.w]k};

// slave process handling
.z.pd:{n:abs system"s";$[n=count handles;handles;[hclose each handles;:handles::`u#hopen each 50001+til n]]};
.z.pc:{handles::`u#handles except x;};
handles:`u#`int$();

// JSON manipulation
.util.parseJson:{.j.k raze raze string x};
.util.curl:{[x;y]system"curl -G ",x," -d ",y};
.util.parseCurl:{.util.parseJson[.util.curl[x;y]]};

// save table to disk
.util.saveTable:{[table;fileName;dir] (hsym `$dir,"/",fileName) set table };

//ipc wrapper to open handle, run query then close handle
// .util.ipc.pull[`lolStats.rdb.1;{x+x};2]
.util.ipc.pull:{[hostPort;query;args] //
    if[not ":"~first string hostPort;hostPort:.util.ipc.mapProcAlias hostPort]; // check if input name is aliased (might be a better way here)
    h:hopen hostPort;
    res:@[h;(query;args);{x}];
    hclose h;
    res
    };

.util.ipc.mapProcAlias:{hsym[`$":"sv string raze  value exec  host,port from .proc.manifest where procname in x]}; //TODO deal with env vars in proc manifest