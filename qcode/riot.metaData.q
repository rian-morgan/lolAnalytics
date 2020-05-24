.api.getChampionMetaData:{.util.parseCurl["http://ddragon.leagueoflegends.com/cdn/10.5.1/data/en_US/champion.json";.api.key]};
.champion.meta:{res:.api.getChampionMetaData[]`data;res:.Q.id([]championName:key res),'(value res);1!update "I"$key1 from res}[];
seasons:.util.parseCurl["http://static.developer.riotgames.com/docs/lol/seasons.json";.api.key];
queues:.util.parseCurl["http://static.developer.riotgames.com/docs/lol/queues.json";.api.key];
maps:.util.parseCurl["http://static.developer.riotgames.com/docs/lol/maps.json";.api.key];
gameModes:.util.parseCurl["http://static.developer.riotgames.com/docs/lol/gameModes.json";.api.key];
gameTypes:.util.parseCurl["http://static.developer.riotgames.com/docs/lol/gameTypes.json";.api.key];
items:.util.parseCurl["http://ddragon.leagueoflegends.com/cdn/10.5.1/data/en_US/item.json";.api.key];
.asset.champion.square:{[champion]
	.util.parseCurl["http://ddragon.leagueoflegends.com/cdn/10.6.1/img/champion/",champion,".png";.api.key]
	};

.discord.bot.token:`Njg2MzA1ODI4MDIxNjAwMjc5.XmVSQQ.L3ex1s2ygK4ipHKsITcRMLqG2bQ;

// LoL account data for discord users
.discord.loadAccountMx[]




