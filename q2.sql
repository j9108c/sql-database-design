\! echo '\n\n\n\n\n'

set search_path to wetworldschema;

-- q2: Find monitors whose average rating is higher than that of all dives sites that the monitor uses. Report each of these monitor’s average booking fee and email.

drop table if exists q2 cascade;

create table q2 (
	id int, -- monitor id
	name varchar(50), -- monitor name
	avg_booking money, -- monitor's average booking fee (using base charges)
	email varchar(50) -- monitor email
);

drop view if exists view1 cascade; 
drop view if exists view2 cascade;
drop view if exists view3 cascade;
drop view if exists view4 cascade;
drop view if exists view5 cascade;
drop view if exists view6 cascade;

create view view1 as -- all dive sites that each monitor used
select distinct monitor_id, site_id
from Booking
order by monitor_id,
	site_id;

create view view2 as -- all dive sites that each monitor used and each site's avg rating
select view1.monitor_id as monitor_id,
	view1.site_id as site_id,
	Site.avg_rating as site_avg_rating
from view1
	join Site on view1.site_id = Site.id
order by view1.monitor_id,
	view1.site_id;

create view view3 as -- all monitors who have been booked at least once and the avg of all the sites theyve used
select distinct view2.monitor_id as monitor_id,
	avg(site_avg_rating) as used_sites_avg
from view2
group by monitor_id;

create view view4 as -- compares each monitors (who have been booked at least once) avg rating with that of all the sites they have used
select view3.monitor_id as monitor_id,
	Monitor.avg_rating as monitor_avg_rating,
	view3.used_sites_avg as used_sites_avg
from view3
	join Monitor on view3.monitor_id = Monitor.id
order by view3.monitor_id;

create view view5 as -- avg booking fees (using base charges) per monitor
select monitor_id,
	avg(base_charge::numeric)::money as avg_booking
from Booking
group by monitor_id
order by monitor_id;

create view view6 as -- final answer
select Monitor.id as id,
	Monitor.name as name,
	view5.avg_booking as avg_booking,
	Monitor.email as email
from Monitor
	join view4 on Monitor.id = view4.monitor_id
	join view5 on view4.monitor_id = view5.monitor_id
where view4.monitor_avg_rating > view4.used_sites_avg
order by Monitor.id;

-- query that answers the question

insert into q2
select * from view6;

-- auto-run views on execution of script (\i) NOTE: comment out when handing in

\! echo '\n view1'
select * from view1;
\! echo '\n view2'
select * from view2;
\! echo '\n view3'
select * from view3;
\! echo '\n view4'
select * from view4;
\! echo '\n view5'
select * from view5;
\! echo '\n view6'
select * from view6;

\! echo '\n q2'
select * from q2;
