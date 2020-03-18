// utility functins serving kdb processes pulling data from riot api

activeWSConnections: ([] handle:(); connectTime:());
queries:([]handle:();queryTime:();func:();res:());

.z.wo:{neg[.z.w]"Hello from Q.";`activeWSConnections upsert (x;.z.t)};
.z.wc:{delete from `activeWSConnections where handle =x};
//.z.ws:{neg[.z.w].Q.s value x};
.z.ws:{k:.j.j @[value;x;{`$ "'",x}];`queries upsert (.z.w;.z.t;x;k);neg[.z.w]k};


.util.parseJsonToQ:{.j.k raze raze string x};
.util.curl:{[x;y]system"curl -G ",x," -d ",y};
.util.parseCurl:{.util.parseJsonToQ[.util.curl[x;y]]};

// save table to disk
.util.saveTable:{[table;fileName;dir] (hsym `$dir,"\\",fileName) set table };

