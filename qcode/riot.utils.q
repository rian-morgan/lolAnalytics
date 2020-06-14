// Dictionary of command line args passes to process
.proc.args:raze each .Q.opt .z.x;

// utility functins serving kdb processes pulling data from riot api

.ws.active:([] handle:(); connectTime:());
.ws.queries:([]handle:();queryTime:();func:();res:());

.z.wo:{neg[.z.w]"Hello from Q.";`.ws.active upsert (x;.z.t)};
.z.wc:{delete from `.ws.active where handle =x};
//.z.ws:{neg[.z.w].Q.s value x};
.z.ws:{k:.j.j @[value;x;{`$ "'",x}];`.ws.queries upsert (.z.w;.z.t;x;k);neg[.z.w]k};


// JSON manipulation
.util.parseJson:{.j.k raze raze string x};
.util.curl:{[x;y]system"curl -G ",x," -d ",y};
.util.parseCurl:{.util.parseJson[.util.curl[x;y]]};

// save table to disk
.util.saveTable:{[table;fileName;dir] (hsym `$dir,"/",fileName) set table };