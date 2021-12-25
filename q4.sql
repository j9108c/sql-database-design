\! echo '\n\n\n\n\n'

set search_path to wetworldschema;

-- q4: For each dive site report the highest, lowest, and average fee charged per dive.

drop table if exists q4 cascade;

create table q4 (
	site_id int,
	highest money, -- highest fee (using base charges) ever charged for this dive site
	lowest money, -- lowest fee (using base charges) ever charged for this dive site
	average money -- average fee (using base charges) charged per dive for this dive site
);

drop view if exists view1 cascade; 
drop view if exists view2 cascade;
drop view if exists view3 cascade;
drop view if exists view4 cascade;
drop view if exists view5 cascade;

create view view1 as -- highest fee (using base charges) ever charged for each dive site
select site_id,
	max(base_charge) as highest,
	0::money as lowest,
	0::money as average
from Booking
group by site_id
order by site_id;

create view view2 as -- lowest fee (using base charges) ever charged for each dive site
select site_id,
	0::money as highest,
	min(base_charge) as lowest,
	0::money as average
from Booking
group by site_id
order by site_id;

create view view3 as -- average fee (using base charges) charged per dive for each dive site
select site_id,
	0::money as highest,
	0::money as lowest,
	avg(base_charge::numeric)::money as average
from Booking
group by site_id
order by site_id;

create view view4 as -- combining the highest, lowest, and average fees into one table
select * from view1
union
select * from view2
union
select * from view3;

create view view5 as -- final answer
select site_id,
	sum(highest) as highest,
	sum(lowest) as lowest,
	sum(average) as average
from view4
group by site_id
order by site_id;

-- query that answers the question

insert into q4
select * from view5;

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

\! echo '\n q4'
select * from q4;
