// Generation of match statistics and analytics 
    
// m:.match.stats.get[region:.api.host[`euw];matchId:"4499685625"]
.match.stats.get:{[region;matchId]
    match:.api.get.match.byMatchId[region;matchId];
    participantIdentities:match[`participantIdentities];
    
    matchStats:update 
        gameId:`$string"j"$match[`gameId],
        platformId:`$match[`platformId],
        gameCreation:"P"$-3_string `long$match[`gameCreation],
        gameDuration:`int$match[`gameDuration],
        queueId:`$string"j"$match[`queueId],
        mapId:`$string"j"$match[`mapId],
        seasonId:`$string"j"$match[`seasonId],
        gameVersion:`$match[`gameVersion],
        gameMode:`$match[`gameMode],
        gameType:`$match[`gameType],
        {(.dd.items[`data]@ x )[`name]} each `$string item0, 
        {(.dd.items[`data]@ x )[`name]} each `$string item1,
        {(.dd.items[`data]@ x )[`name]} each `$string item2,
        {(.dd.items[`data]@ x )[`name]} each `$string item3,
        {(.dd.items[`data]@ x )[`name]} each `$string item4,
        {(.dd.items[`data]@ x )[`name]} each `$string item5,
        {(.dd.items[`data]@ x )[`name]} each `$string item6,
        `long$participantId 
       from match[`participants][`stats];
    cnt:count matchStats;
    sn:([participantId:1+til count matchStats] 
        summonerName:{x[`summonerName]}'[(exec player from participantIdentities)];
        accountId:{`$x[`accountId]}'[(exec player from participantIdentities)]);
    matchStats:matchStats lj sn;
    cls:exec c from meta[matchStats] where t="f";                   // select any columns with type float, these need to be longs
    matchStats:![matchStats;();0b;cls!({($;"j"),x}'[cls])];         // cast float columns to longs
    missingCols:cols[.match.stats.schema[]] except cols[matchStats];  // check if any columns are missing
    if[not 0=count missingCols;matchStats:matchStats lj 1!update participantId:1+til count matchStats from 10#?[.match.stats.schema;();0b;c!c:`participantId,missingCols]]; // add on missing columns
    `participantId`summonerName`accountId`gameId xcols matchStats
    };

// px:.player.stats.get[region:.api.host[`euw];accountId:"cwNgwUdB3IpTb08PB5VounuqCRC3JuBThZtAX64YCZZ_3tM";games:10;enlist[`champion]!enlist[86]]   
.player.stats.get:{[region;accountId;games;filters]
    data:.api.get.match.matchListByAccountId[region;accountId;filters];
    matches:data[`matches];
    matchId:exec gameId from matches;
    if[not games=0;matchId:games sublist matchId];
    t:.match.stats.get[region;]'[string matchId];
    /cls:distinct raze cols each t;
    /ncls:except[cls;]'[cols each t];
    /upd:{cc:count x;t:$[1=count x;enlist[x];x];t!cc#enlist(#;(count;`i);())};
    /nupd:upd'[ncls];
    /tt:{![x;();0b;y]}'[t;nupd]
    id:`$accountId;
    playerStats:?[uj/[t];enlist (in;`accountId;`id);0b;()];
    playerStats
    };