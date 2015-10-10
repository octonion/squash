begin;

drop table if exists csa.match_games;

create table csa.match_games (
	result_id			integer,
	player_team_id			integer,
	player_team_name		text,
	opponent_team_id		integer,
	opponent_team_name		text,
	ladder_id			text,
	player_won			boolean,
	player_name			text,
	player_url			text,
	player_id			integer,
	player_rating			text,
	opponent_won			boolean,
	opponent_name			text,
	opponent_url			text,
	opponent_id			integer,
	opponent_rating			text,
	scores				text,
	winner				text,
	status				text,
	primary key (result_id,ladder_id)
);

copy csa.match_games from '/tmp/match_games.csv' with delimiter as ',' csv quote as '"';

commit;
