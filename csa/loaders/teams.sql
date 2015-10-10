begin;

drop table if exists csa.teams;

create table csa.teams (
        team_name			text,
	team_url			text,
	team_id				integer,
	coach_name			text,
	coach_url			text,
	coach_id			integer,
	standing			integer,
	wins				integer,
	losses				integer,
	ties				integer,
	individual_matches_wins		integer,
	individual_matches_losses	integer,
	individual_games_wins		integer,
	individual_games_losses		integer,
	individual_points_wins		integer,
	individual_points_losses	integer,
	primary key (team_id)
);

copy csa.teams from '/tmp/teams.csv' with delimiter as ',' csv quote as '"';

commit;
