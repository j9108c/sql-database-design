\! echo '\n\n\n\n\n'

set search_path to wetworldschema;

-- q1: For each dive category from open water, cave, or beyond 30 meters, list the number of dive sites that provide that dive type and have at least one monitor with booking privileges with them who will supervise groups for that type of dive.

drop table if exists q1 cascade;

create table q1 (
	num_sites_open int, -- for open water dive
	num_sites_cave int, -- for cave dive
	num_sites_deep int -- for beyond 30m dive
);

drop view if exists view1 cascade; 
drop view if exists view2 cascade;
drop view if exists view3 cascade;
drop view if exists view4 cascade;

create view view1 as -- number of sites that provide open dive and have at least one monitor with booking privileges with them who will supervise groups for open dive
select count(distinct Site.id) as num_sites_open
from Site
	join MonitorPrivPrice
		on Site.id = MonitorPrivPrice.site_id
	join MonitorMGS
		on MonitorPrivPrice.monitor_id = MonitorMGS.monitor_id
where Site.has_open = true
	and MonitorPrivPrice.privilege = true
	and MonitorMGS.dive_type = 'open'
	and MonitorMGS.mgs >= 1;

create view view2 as -- number of sites that provide cave dive and have at least one monitor with booking privileges with them who will supervise groups for cave dive
select count(distinct Site.id) as num_sites_cave
from Site
	join MonitorPrivPrice
		on Site.id = MonitorPrivPrice.site_id
	join MonitorMGS
		on MonitorPrivPrice.monitor_id = MonitorMGS.monitor_id
where Site.has_cave = true
	and MonitorPrivPrice.privilege = true
	and MonitorMGS.dive_type = 'cave'
	and MonitorMGS.mgs >= 1;

create view view3 as -- number of sites that provide deep dive and have at least one monitor with booking privileges with them who will supervise groups for deep dive
select count(distinct Site.id) as num_sites_deep
from Site
	join MonitorPrivPrice
		on Site.id = MonitorPrivPrice.site_id
	join MonitorMGS
		on MonitorPrivPrice.monitor_id = MonitorMGS.monitor_id
where Site.has_deep = true
	and MonitorPrivPrice.privilege = true
	and MonitorMGS.dive_type = 'deep'
	and MonitorMGS.mgs >= 1;

create view view4 as -- final answer
select *
from view1
	cross join view2
	cross join view3;

-- query that answers the question

insert into q1
select * from view4;

-- auto-run views on execution of script (\i) NOTE: comment out when handing in

\! echo '\n view1'
select * from view1;
\! echo '\n view2'
select * from view2;
\! echo '\n view3'
select * from view3;
\! echo '\n view4'
select * from view4;

\! echo '\n q1'
select * from q1;
