// Generation of match statistics and analytics 

// need schema for match as riot api does not send cols with no data ie in case of remake
// 
// (cols .match.stats.get[region:.api.host[`euw];matchId:"4499685625"]) except cols .match.stats.schema[];
/.match.stats.schema:{
    // no official schema, this will need to be updated if a new field is found from api
/    c:`summonerName`accountId`perk0Var2`statPerk0`statPerk1`statPerk2`item0`item2`totalUnitsHealed`item1`largestMultiKill`goldEarned`firstInhibitorKill`physicalDamageTaken`nodeNeutralizeAssist`totalPlayerScore`champLevel`damageDealtToObjectives`totalDamageTaken`neutralMinionsKilled`deaths`tripleKills`magicDamageDealtToChampions`wardsKilled`pentaKills`damageSelfMitigated`largestCriticalStrike`nodeNeutralize`totalTimeCrowdControlDealt`firstTowerKill`magicDamageDealt`totalScoreRank`nodeCapture`wardsPlaced`totalDamageDealt`timeCCingOthers`magicalDamageTaken`largestKillingSpree`totalDamageDealtToChampions`physicalDamageDealtToChampions`neutralMinionsKilledTeamJungle`totalMinionsKilled`firstInhibitorAssist`visionWardsBoughtInGame`objectivePlayerScore`kills`firstTowerAssist`combatPlayerScore`inhibitorKills`turretKills`participantId`trueDamageTaken`firstBloodAssist`nodeCaptureAssist`assists`teamObjective`altarsNeutralized`goldSpent`damageDealtToTurrets`altarsCaptured`win`totalHeal`unrealKills`visionScore`physicalDamageDealt`firstBloodKill`longestTimeSpentLiving`killingSprees`sightWardsBoughtInGame`trueDamageDealtToChampions`neutralMinionsKilledEnemyJungle`doubleKills`trueDamageDealt`quadraKills`item4`item3`item6`item5`playerScore0`playerScore1`playerScore2`playerScore3`playerScore4`playerScore5`playerScore6`playerScore7`playerScore8`playerScore9`perk0`perk0Var1`perk0Var3`perk1`perk1Var1`perk1Var2`perk1Var3`perk2`perk2Var1`perk2Var2`perk2Var3`perk3`perk3Var1`perk3Var2`perk3Var3`perk4`perk4Var1`perk4Var2`perk4Var3`perk5`perk5Var1`perk5Var2`perk5Var3`perkPrimaryStyle`perkSubStyle;
/    flip c!(count c)#()
/    };
 
// Temporarily use known game for schema     
.match.stats.schema:{
    0#.match.stats.get[region:.api.host[`euw];matchId:"4499685625"]
    }[];
    
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
    missingCols:cols[.match.stats.schema] except cols[matchStats];  // check if any columns are missing
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