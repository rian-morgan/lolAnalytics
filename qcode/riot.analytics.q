// Generation of match statistics and analytics 
    
// match:.match.stats.get[region:.api.host[`euw];matchId:"4499685625"]
.match.stats.get:{[region;matchId]
    match:.api.get.match.byMatchId[region;matchId];
    participantIdentities:match[`participantIdentities];
    if[0h~type match[`participants];
        match[`participants]:uj/[enlist each  match[`participants]]];

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
    sn:([participantId:1+til cnt] 
        summonerName:{x[`summonerName]}'[(exec player from participantIdentities)];
        accountId:{`$x[`accountId]}'[(exec player from participantIdentities)];
        championId:"j"$exec championId from match[`participants]);
    matchStats:matchStats lj sn;
    cls:exec c from meta[matchStats] where t="f";                   // select any columns with type float, these need to be longs
    matchStats:![matchStats;();0b;cls!({($;"j"),x}'[cls])];         // cast float columns to longs
    missingCols:cols[.match.stats.schema[]] except cols[matchStats];  // check if any columns are missing
    if[not 0=count missingCols;matchStats:matchStats lj 1!update participantId:1+til cnt from cnt#?[.match.stats.schema[];();0b;c!c:`participantId,missingCols]]; // add on missing columns
    `participantId`summonerName`accountId`gameId`championId xcols matchStats
    };

// px:.player.stats.get[region:.api.host[`euw];accountId:"cwNgwUdB3IpTb08PB5VounuqCRC3JuBThZtAX64YCZZ_3tM";games:0;filters:enlist[`champion]!enlist[86]]  
//.player.stats.get x:`region`accountId`sDatetime`eDatetime`filters!(.api.host[`euw];"cwNgwUdB3IpTb08PB5VounuqCRC3JuBThZtAX64YCZZ_3tM";"p"$.z.d-250D;.z.p;enlist[`champion]!enlist[86])
.player.stats.get:{ //[region;accountId;games;filters]
    op:`region`accountId`sDatetime`eDatetime`filters`games!("";"";-0Wp;.z.p;()!();0);$[99h~type x;op:op,x;op];
    data:.api.get.match.matchListByAccountId[op[`region];op[`accountId];op[`filters]];
    data:select from data where timestamp within (op[`sDatetime];op[`eDatetime]);
    //matches:data[`matches];
    matches:data;
    matchId:exec gameId from matches where queue within (400;440); // que cond ensures only 5v5 on summoners rift
    if[not op[`games]=0;matchId:op[`games] sublist matchId];
    t:.match.stats.get[op[`region];] peach string matchId; //use when slave processes are available
    id:`$op[`accountId];
    playerStats:?[uj/[t];enlist (in;`accountId;`id);0b;()]; //select only players matches
    champs:value exec id,championNumber from .champion.meta;
    champMap:champs[1]!champs[0];
    playerStats:update champMap@championId from playerStats;
    playerStats
    };

.web.get.myStats:{[region;accountName;champion;stat;sDatetime;eDatetime]
    accountId:.api.get.summoner.byName[.api.host[region];accountName][`accountId];
    champs:value exec id,championNumber from .champion.meta;
    champMap:champs[0]!champs[1];
    sDatetime:"P"$sDatetime;
    eDatetime:"P"$eDatetime;
    px:.player.stats.get[x:`region`accountId`filters`games`sDatetime`eDatetime!(.api.host[region];accountId;enlist[`champion]!enlist[champMap@champion];5;sDatetime;eDatetime)];
    px:update kda:(kills+assists)%?[deaths=0;1;deaths], csPerMin:60*totalMinionsKilled%gameDuration from px;  
    color:"," sv string (3?til 256);
    border:"rgba(",color,",1)";
    bgColor:"rgba(",color,",0.2)";
    `label`data`borderColor`backgroundColor!(stat;?[px;();0b;`x`y!(`gameCreation;stat)];border;bgColor)
    };
            
makeContext:{
    accounts:exec lolAccount from .discord.accountMx;
    regions:exec distinct lolRegion from .discord.accountMx;
    champion:exec id from .champion.meta;
    context:`accounts`regions`champion!(accounts;regions;champion);
    context
    };
 