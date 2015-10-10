begin;

drop table if exists csa.matches;

create table csa.matches (
        team_name			text,
	team_id				integer,
	status				text,
	match_date			text,
	result_url			text,
	result_id			integer,
	opponent_name			text,
	opponent_url			text,
	opponent_id			integer,
	site				text,
	outcome				text,
	score				text,
	team_score			integer,
	opponent_score			integer,
	blank_score_card		text,
	notes				text,
	adjust				text,
	unique (team_id,result_id)
);

copy csa.matches from '/tmp/matches.csv' with delimiter as ',' csv quote as '"';

commit;
