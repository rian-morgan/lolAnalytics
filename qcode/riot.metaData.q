.dd.versions.all:{.util.parseCurl["https://ddragon.leagueoflegends.com/api/versions.json";.api.key]}[];
.dd.versions.latest:first .dd.versions.all;
.dd.seasons:.util.parseCurl["http://static.developer.riotgames.com/docs/lol/seasons.json";.api.key];
.dd.queues:.util.parseCurl["http://static.developer.riotgames.com/docs/lol/queues.json";.api.key];
.dd.maps:.util.parseCurl["http://static.developer.riotgames.com/docs/lol/maps.json";.api.key];
.dd.gameModes:.util.parseCurl["http://static.developer.riotgames.com/docs/lol/gameModes.json";.api.key];
.dd.gameTypes:.util.parseCurl["http://static.developer.riotgames.com/docs/lol/gameTypes.json";.api.key];
.dd.items:.util.parseCurl["http://ddragon.leagueoflegends.com/cdn/",.dd.versions.latest,"/data/en_US/item.json";.api.key];
.cd.runes:.util.parseJson system"curl -G http://raw.communitydragon.org/latest/plugins/rcp-be-lol-game-data/global/default/v1/perks.json";
.dd.getChampionMetaData:{.util.parseCurl["http://ddragon.leagueoflegends.com/cdn/",.dd.versions.latest,"/data/en_US/champion.json";.api.key]};

.champion.schema.meta:flip `id`championNumber`version`name`title`blurb`info`image`tags`partype`stats`key1`skins`lore`allytips`enemytips`spells`passive`recommended!(`$();`int$();"";"";"";"";();();();"";();"";();"";();();();();());   

.champion.metaLoad:{
    .log.info["Loading champion meta data from disk"];
    @[{.champion.meta:get hsym`$getenv[`RITODATA],"/championMeta"};
    ::;
    {.log.warn["No meta data found on disk."];.champion.meta:.champion.schema.meta;}];
    ver:distinct exec version from .champion.meta;
    if[(not (first ver)~.dd.versions.latest)|(not 1 = count ver);.log.info["New version of metadata available. Rebuilding table."];.champion.metaUpdate[]];
    .log.info[".champion.meta table loaded."];
    //.champion.metaSave[]; // removing this to run explicitly in rdb.0
    };

.champion.metaSave:{
    .log.info["Saving .champion.meta to disk."];
    .util.saveTable[.champion.meta;"championMeta";getenv[`RITODATA]];
    .log.info[".champion.meta saved to disk."];
    };
    
.champion.metaUpdate:{
    .log.info["Updating .champion.meta"];
    res:.dd.getChampionMetaData[]`data;
    res:.Q.id(value res);
    .champion.meta:1!`id`championNumber xcols delete key1 from update `$id,championNumber:"I"$key1 from res;
    .champion.meta:.champion.meta lj 
        update `$id from 1!,/[{.log.info["Enriching metadata for ",string[x]];value {.util.parseCurl["http://ddragon.leagueoflegends.com/cdn/",.dd.versions.latest,"/data/en_US/champion/",string[x],".json";.api.key]}[x][`data]}
            '[exec id from .champion.meta]];
    };


.asset.champion.square:{[champion]
	.util.parseCurl["http://ddragon.leagueoflegends.com/cdn/",.dd.versions.latest,"/img/champion/",champion,".png";.api.key]
	};

.discord.bot.token:`Njg2MzA1ODI4MDIxNjAwMjc5.XmVSQQ.L3ex1s2ygK4ipHKsITcRMLqG2bQ;






