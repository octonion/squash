#!/bin/bash

cmd="psql template1 --tuples-only --command \"select count(*) from pg_database where datname = 'squash';\""

db_exists=`eval $cmd`
 
if [ $db_exists -eq 0 ] ; then
   cmd="createdb squash;"
   eval $cmd
fi

psql squash -f schema/namespace.sql

cp csv/teams.csv /tmp/teams.csv
psql squash -f loaders/teams.sql
rm /tmp/teams.csv

cp csv/matches.csv /tmp/matches.csv
psql squash -f loaders/matches.sql
rm /tmp/matches.csv

cp csv/match_outcomes.csv /tmp/match_outcomes.csv
psql squash -f loaders/match_outcomes.sql
rm /tmp/match_outcomes.csv

cp csv/match_games.csv /tmp/match_games.csv
psql squash -f loaders/match_games.sql
rm /tmp/match_games.csv

psql squash -f loaders/match_sets.sql
