//.api.get.summoner.byName[.api.host`euw;"Tenadoul"]
//.api.get.match.matchListByAccountId[.api.host`euw;"cwNgwUdB3IpTb08PB5VounuqCRC3JuBThZtAX64YCZZ_3tM"]`matches
//.api.get.match.matchListBySummonerName[.api.host`euw;"Tenadoul"]`matches

.api.key:"RGAPI-1907148d-6fa6-4cf2-9a64-f20df7b71378";
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

.api.get.match.matchListByAccountId:{[region;accountId]
    req:"https://",region,.api.match,"/matchlists/by-account/",accountId;
    query:"api_key=",.api.key;
    d:.j.k raze raze string system"curl -G ",req," -d ",query;
    k:select `$platformId,`long$gameId,champion,queue,season,`$role,`$lane,"P"$-3_'string `long$timestamp from d`matches;
    d[`matches]:k;
    d
    };

.api.get.match.matchListBySummonerName:{[region;name]
    accountId:.api.get.summoner.byName[region;name]`accountId;
    d:.api.get.match.matchListByAccountId[region;accountId];
    d
    };

.api.get.matchTimelines:{[region;matchId]
    req:"https://",region,.api.match,"/timelines/by-match/",matchId;
    query:"api_key=",.api.key;
    d:.j.k raze raze string system"curl -G ",req," -d ",query;
    d
    };
// TODO make region always lowercase
.discord.setAccountMx:{[x;y;z]`.discord.accountMx upsert ([discordId:enlist x]lolAccount:enlist y;lolRegion:enlist z);
    .util.saveTable[.discord.accountMx;"lolAccountMx";getenv[`RITODATA]];
    };

.discord.loadAccountMx:{ 
    @[{.discord.accountMx:get hsym`$getenv[`RITODATA],"\\lolAccountMx"};
    ::;
    {.discord.accountMx:([discordId:`$()]lolAccount:"C"$();lolRegion:`$())}]
    };



// .discord.get.summoner.byName id:`278255127393992704
.discord.get.summoner.byName:{[id]
    name:.discord.accountMx[id]`lolAccount;
    region:.api.host .discord.accountMx[id]`lolRegion;
    .api.get.summoner.byName[region;name]};
    

