begin;

drop table if exists csa.match_outcomes;

create table csa.match_outcomes (
	result_id			integer,
	result_date			date,
	team_name			text,
	team_url			text,
	team_id				integer,
	team_games_won			integer,
	opponent_name			text,
	opponent_url			text,
	opponent_id			integer,
	opponent_games_won		integer,
	unique (result_id)
);

copy csa.match_outcomes from '/tmp/match_outcomes.csv' with delimiter as ',' csv quote as '"';

commit;
