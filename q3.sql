\! echo '\n\n\n\n\n'

set search_path to wetworldschema;

-- q3: Find the average fee charged per dive (including extra charges) for dive sites that are more than half full on average, and for those that are half full or less on average. Consider both weekdays and weekends for which there is booking information. Capacity includes all divers, including monitors, at a site at a morning, afternoon, or night dive opportunity.

drop table if exists q3 cascade;

create table q3 (
	avg_fee_mt_hf money, -- avg fee charged per dive (incl extra charges) for sites that are more than half full on average
	avg_fee_leq_hf money -- avg fee charged per dive (incl extra charges) for sites that are less than or exactly half full on average
);

drop view if exists view1 cascade; 
drop view if exists view2 cascade;
drop view if exists view3 cascade;
drop view if exists view4 cascade;
drop view if exists view5 cascade;
drop view if exists view6 cascade;
drop view if exists view7 cascade;
drop view if exists view8 cascade;
drop view if exists view9 cascade;
drop view if exists view10 cascade;
drop view if exists view11 cascade;
drop view if exists view12 cascade;
drop view if exists view13 cascade;
drop view if exists view14 cascade;

create view view1 as -- booking info
select site_id,
	tod_type,
	num_divers,
	max_charge
from Booking
order by site_id;

create view view2 as -- day and night capacities of each site
select id as site_id,
	cap_day,
	cap_night
from Site
order by id;

create view view3 as -- half of full capacities of day and night of each site
select site_id,
	cap_day/2.0 as hf_cap_day,
	cap_night/2.0 as hf_cap_night
from view2
order by site_id;

create view view4 as -- for all sites that were booked at least once, gives the number of bookings which had more divers (incl monitor) than half of the full capacity of the site
select view1.site_id,
	count(view1.site_id) as mt_hf
from view1
	join view3 on view1.site_id = view3.site_id
where ((view1.tod_type = 'm_open' or view1.tod_type = 'm_cave' or view1.tod_type = 'm_deep' or view1.tod_type = 'a_open' or view1.tod_type = 'a_cave' or view1.tod_type = 'a_deep') and (view1.num_divers+1 > view3.hf_cap_day))
	or ((view1.tod_type = 'n_open' or view1.tod_type = 'n_cave' or view1.tod_type = 'n_deep') and (view1.num_divers+1 > view3.hf_cap_night))
group by view1.site_id
order by view1.site_id,
	count(view1.site_id);

create view view5 as -- for all sites that were booked at least once, gives the number of bookings which had (incl monitor) less than or exactly half of the full capacity of the site
select view1.site_id,
	count(view1.site_id) as leq_hf
from view1
	join view3 on view1.site_id = view3.site_id
where ((view1.tod_type = 'm_open' or view1.tod_type = 'm_cave' or view1.tod_type = 'm_deep' or view1.tod_type = 'a_open' or view1.tod_type = 'a_cave' or view1.tod_type = 'a_deep') and (view1.num_divers+1 <= view3.hf_cap_day))
	or ((view1.tod_type = 'n_open' or view1.tod_type = 'n_cave' or view1.tod_type = 'n_deep') and (view1.num_divers+1 <= view3.hf_cap_night))
group by view1.site_id
order by view1.site_id,
	count(view1.site_id);

create view view6 as -- all distinct site id's from view4 and view5 together
select site_id from view4
union
select site_id from view5
order by site_id;

create view view7 as -- for all sites that were booked at least once, gives: the number of bookings which had more divers (incl monitor) than half of the full capacity of the site AND the number of bookings which had (incl monitor) less than or exactly half of the full capacity of the site
select view6.site_id as site_id,
	coalesce(view4.mt_hf, 0) as mt_hf,
	coalesce(view5.leq_hf, 0) as leq_hf
from view6
	full join view4 on view6.site_id = view4.site_id
	full join view5 on view6.site_id = view5.site_id
order by view6.site_id;

create view view8 as -- all sites that are more than half full on average
select site_id as avg_mt_hf_site_id
from view7
where mt_hf > leq_hf
order by site_id;

create view view9 as -- all sites that are less than or exactly half full on average
select site_id as avg_leq_hf_site_id
from view7
where leq_hf >= mt_hf
order by site_id;

create view view10 as -- for each site that is more than half full on average, the avg fee for the site
select view8.avg_mt_hf_site_id as avg_mt_hf_site_id,
	avg(view1.max_charge::numeric)::money as avg_fee
from view8
	join view1 on view8.avg_mt_hf_site_id = view1.site_id
group by view8.avg_mt_hf_site_id
order by view8.avg_mt_hf_site_id;

create view view11 as -- for each site that is less than or exactly half full on average, the avg fee for the site
select view9.avg_leq_hf_site_id as avg_leq_hf_site_id,
	avg(view1.max_charge::numeric)::money as avg_fee
from view9
	join view1 on view9.avg_leq_hf_site_id = view1.site_id
group by view9.avg_leq_hf_site_id
order by view9.avg_leq_hf_site_id;

create view view12 as -- the avg of the combined avg fees of all sites that are more than half full on average
select avg(avg_fee::numeric)::money as avg_fee_mt_hf
from view10;

create view view13 as -- the avg of the combined avg fees of all sites that are less than or exactly than half full on average
select avg(avg_fee::numeric)::money as avg_fee_leq_hf
from view11;

create view view14 as -- final answer
select * from view12 cross join view13;

-- query that answers the question

insert into q3
select * from view14;

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
\! echo '\n view7'
select * from view7;
\! echo '\n view8'
select * from view8;
\! echo '\n view9'
select * from view9;
\! echo '\n view10'
select * from view10;
\! echo '\n view11'
select * from view11;
\! echo '\n view12'
select * from view12;
\! echo '\n view13'
select * from view13;
\! echo '\n view14'
select * from view14;

\! echo '\n q3'
select * from q3;
