begin;

--SELECT id, elem, rn
--FROM   tbl, unnest(string_to_array(elements, ',')) WITH ORDINALITY x(elem, rn);

drop table if exists csa.match_sets;

create table csa.match_sets (
       result_id		text,
       ladder_id		text,
       set_number		integer,
       set_score		text,
       winner_score		integer,
       loser_score		integer,
       primary key (result_id,ladder_id,set_number)
);

insert into csa.match_sets
(result_id,ladder_id,set_number,set_score,winner_score,loser_score)
(
select
result_id,
ladder_id,
set_number,
set_score,
split_part(set_score,'-',1)::integer,
split_part(set_score,'-',2)::integer
from csa.match_games, unnest(string_to_array(scores,','))
  with ordinality scores(set_score, set_number)
where scores not like '%unknown%'
);

commit;

