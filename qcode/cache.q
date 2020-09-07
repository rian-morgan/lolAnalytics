// cacheing
// .player.stats.get needs to check a cache for any games that have already been cached (use matchId for this) 
// check what matchIds are already in cache,  request any that arent, update cache with these matches, pull all matches from cache

//.cache.player.stats.data - use this to store data, raw data from api, before derived columns are added (e.g. kda)
//.cache.player.stats.meta - store matchId

match:.match.stats.get[region:.api.host[`euw];matchId:"4499685625"];
data:exec first matchId:gameId,first gameCreation, summonerName, accountId from match;
meta .cache.playr.stats.schema.meta
.cache.player.stats.schema.meta:1!flip `matchId`gameCreation`summonerName`accountId`lastAccess!(`$();`timestamp$();(),"";`$();`timestamp$());
.cache.player.stats.meta:.cache.player.stats.schema.meta;

.cache.plater.stats.update:{[data]
    //update meta and data caches with match data
    metadata:flip `matchId`gameCreation`summonerName`accountId`lastAccess!(n:count data`accountId)#/:data[`matchId`gameCreation],data[`summonerName`accountId],(enlist n#.z.p);
    `.cache.player.stats.meta upsert 
    meta metadata
    };
    
.cache.plater.stats.update[data]

last match[`participantIdentities][0]

