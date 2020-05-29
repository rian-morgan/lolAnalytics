//.api.get.summoner.byName[.api.host`euw;"Tenadoul"]
//.api.get.match.matchListByAccountId[region:.api.host`euw;accountId:"cwNgwUdB3IpTb08PB5VounuqCRC3JuBThZtAX64YCZZ_3tM"]`matches
//.api.get.match.matchListBySummonerName[.api.host`euw;"Tenadoul"]`matches

.api.key:"RGAPI-8d7391fe-fba9-4bb3-b367-f868137b769c";
.api.host:`euw`na!("euw1.api.riotgames.com";"na1.api.riotgames.com");

.api.status:"/lol/status/v3/shard-data/";
.api.summoners:"/lol/summoner/v4/summoners/";
.api.match:"/lol/match/v4";

name:"Tenadoul";
region:.api.host`euw;


.api.get.summoner.byName:{[region;name]
    req:"https://",region,.api.summoners,"by-name/",name;
    query:"api_key=",.api.key;
    d:.j.k raze raze string system"curl -G ",req," -d ",query;
    d[`revisionDate]:"P"$-3_string `long$d[`revisionDate];
    d
    };

// .api.get.match.matchListByAccountId[region:.api.host`euw;accountId:"cwNgwUdB3IpTb08PB5VounuqCRC3JuBThZtAX64YCZZ_3tM";filters:enlist[`champion]!enlist[86]]
.api.get.match.matchListByAccountId:{[region;accountId;filters]
    req:"https://",region,.api.match,"/matchlists/by-account/",accountId;
    q:$[0=count value[filters];
        "";
        "-d ",-1_raze raze string each flip k cut key[filters],(k#`$"="),value[filters],((k:count[filters])#`$"&")];
    query:q;
    d:.j.k raze system"curl -G ",req," -H 'X-Riot-Token:",.api.key,"' ",query;
    k:select `$platformId,`long$gameId,champion,queue,season,`$role,`$lane,"P"$-3_'string `long$timestamp from d[`matches];
    d[`matches]:k;
    d
    };

.api.get.match.matchListBySummonerName:{[region;name]
    accountId:.api.get.summoner.byName[region;name]`accountId;
    d:.api.get.match.matchListByAccountId[region;accountId];
    d
    };

// game:.api.get.match[region:.api.host[`euw];matchId:"4499685625"]    
.api.get.match.byMatchId:{[region;matchId]
    req:"https://",region,.api.match,"/matches/",matchId;
    query:"api_key=",.api.key;
    d:.j.k raze system"curl -G ",req," -d ",query;
    d
    };
    
.api.get.matchTimelines:{[region;matchId]
    req:"https://",region,.api.match,"/timelines/by-match/",matchId;
    query:"api_key=",.api.key;
    d:.j.k raze system"curl -G ",req," -d ",query;
    d
    };
    
// .discord.setAccountMx[x:`$"278255127393992704";y:`$"Tenadoul";z:`euw]
// TODO make region always lowercase
.discord.setAccountMx:{[x;y;z]
    `.discord.accountMx upsert ([discordId:enlist x]lolAccount:enlist y;lolRegion:enlist z);
    .util.saveTable[.discord.accountMx;"lolAccountMx";getenv[`RITODATA]];
    };

// .discord.loadAccountMx[]
.discord.loadAccountMx:{ 
    @[{.discord.accountMx:get hsym`$getenv[`RITODATA],"\\lolAccountMx"};
    ::;
    {.discord.accountMx:([discordId:`$()]lolAccount:`$();lolRegion:`$())}]
    };



// .discord.get.summoner.byName id:`278255127393992704
.discord.get.summoner.byName:{[id]
    name:string .discord.accountMx[id]`lolAccount;
    region:.api.host .discord.accountMx[id]`lolRegion;
    .api.get.summoner.byName[region;name]};
    

