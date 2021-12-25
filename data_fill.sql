\! echo '\n\n\n\n\n'

set search_path to wetworldschema;

-- populate database with sample data, specified by data.txt

-- 1

insert into Site
values (0, 'Bloody Bay Marine Park', NULL, true, true, true, 10, 5, 5, 5, 10);

insert into SiteAddOn
values (0, 0, 0, 0, 5, NULL, 10, NULL);

insert into Diver
values (0, 'Jim', 50, 'NAUI', 10000, 'jim@dm.org');

insert into SiteRating
values (0, 3, 0);

update Site
set avg_rating = ((select coalesce(sum(rating), 0) from SiteRating where site_id = 0)::float / (select coalesce(count(rating), 1) from SiteRating where site_id = 0)::float)
where id = 0;

-- 2

insert into Site
values (1, 'Widow Maker’s Cave', NULL, true, true, true, 10, 5, 5, 5, 20);

insert into Diver
values (1, 'Dwight', 50, 'NAUI', 10001, 'dwight@dm.org'),
	(2, 'Pam', 50, 'NAUI', 10002, 'pam@dm.org');

insert into SiteRating
values (1, 0, 1),
	(1, 1, 2),
	(1, 2, 0);

update Site
set avg_rating = ((select coalesce(sum(rating), 0) from SiteRating where site_id = 1)::float / (select coalesce(count(rating), 1) from SiteRating where site_id = 1)::float)
where id = 1;

insert into SiteAddOn
values (1, 0, 0, 0, 3, NULL, 5, NULL);

-- 3

insert into Site
values (2, 'Crystal Bay', NULL, true, true, true, 10, 5, 5, 5, 15);

insert into Diver
values (3, 'Andy', 50, 'NAUI', 10003, 'andy@dm.org'),
	(4, 'Michael', 50, 'NAUI', 10004, 'michael@dm.org'),
	(5, 'Oscar', 50, 'NAUI', 10005, 'oscar@dm.org');

insert into SiteRating
values (2, 4, 3),
	(2, 5, 2),
	(2, 2, 4),
	(2, 3, 5);

update Site
set avg_rating = ((select coalesce(sum(rating), 0) from SiteRating where site_id = 2)::float / (select coalesce(count(rating), 1) from SiteRating where site_id = 2)::float)
where id = 2;

insert into SiteAddOn
values (2, 0, 0, 0, NULL, NULL, 5, 20);

-- 4

insert into Site
values (3, 'Batu Bolong', NULL, true, true, true, 10, 5, 5, 5, 15);

insert into SiteAddOn
values (3, 0, 0, 0, 10, NULL, NULL, 30);

-- 5

insert into Monitor
values (0, 'Maria', NULL, 10, 'maria@dm.org');

insert into MonitorMGS
values (0, 'open', 10),
	(0, 'cave', 5),
	(0, 'deep', 5);

insert into MonitorPrivPrice
values (0, 0, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 25, NULL),
	(0, 1, true, 10, 20, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(0, 2, true, NULL, NULL, NULL, 15, NULL, NULL, NULL, NULL, NULL),
	(0, 3, false, NULL, 30, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- 6

insert into Monitor
values (1, 'John', NULL, 15, 'john@dm.org');

insert into MonitorPrivPrice
values (1, 0, true, NULL, 15, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(1, 2, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- 7

insert into Monitor
values (2, 'Ben', NULL, 15, 'ben@dm.org');

insert into MonitorMGS
values (2, 'open', 15),
	(2, 'cave', 5),
	(2, 'deep', 5);

insert into MonitorPrivPrice
values (2, 1, true, NULL, 20, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- 8

update Diver
set age = extract(year from age(timestamp '1967-03-15'))
where id = 4;

insert into Booking
values (0, '2019-07-20 09:30:00', 4, 0, 1, 'm_open', 1, 30, 38),
	(1, '2019-07-21 09:30:00', 4, 0, 1, 'm_cave', 1, 40, 48);

insert into Dive
values (0, 4, true),
	(1, 4, true);

insert into MonitorRating
values (0, 2, 4),
	(0, 0, 4);

update Monitor
set avg_rating = ((select coalesce(sum(rating), 0) from MonitorRating where monitor_id = 0)::float / (select coalesce(count(rating), 1) from MonitorRating where monitor_id = 0)::float)
where id = 0;

-- 9

update Diver
set name = 'Dwight Schrute'
where id = 1;

update Diver
set name = 'Jim Halpert'
where id = 0;

update Diver
set name = 'Pam Beesly'
where id = 2;

update Booking
set num_divers = 5,
	base_charge = 110,
	max_charge = 150
where id = 0;

insert into Dive
values (0, 1, false),
	(0, 0, false),
	(0, 2, false),
	(0, 3, false);

update Booking
set num_divers = 3,
	base_charge = 80,
	max_charge = 104
where id = 1;

insert into Dive
values (1, 1, false),
	(1, 0, false);

-- 10

insert into MonitorPrivPrice
values (2, 0, false, 30, 30, 30, 30, 30, 30, 30, 30, 30);

insert into Booking
values (2, '2019-07-22 09:30:00', 4, 2, 0, 'm_cave', 2, 50, 80);

insert into Dive
values (2, 4, true),
	(2, 0, false);

insert into MonitorRating
values (2, 5, 4);

update Monitor
set avg_rating = ((select coalesce(sum(rating), 0) from MonitorRating where monitor_id = 2)::float / (select coalesce(count(rating), 1) from MonitorRating where monitor_id = 2)::float)
where id = 2;

-- 11

insert into Booking
values (3, '2019-07-22 20:30:00', 4, 0, 0, 'n_cave', 1, 35, 50);

insert into Dive
values (3, 4, true);

-- 12

update Diver
set name = 'Andy Bernard',
	age = extract(year from age(timestamp '1973-10-10'))
where id = 3;

update Booking
set lead_id = 3
where id = 1
	or id = 2
	or id = 3;

update Dive
set diver_id = 3
where (lead = true)
	and (booking_id = 1 or booking_id = 2 or booking_id = 3);

update MonitorRating
set rater_id = 3
where (monitor_id = 0 and rating = 0)
	or (monitor_id = 2 and rating = 5);

-- 13

insert into Diver
values (6, 'Phyllis', 50, 'NAUI', 10006, 'phyllis@dm.org');

insert into Booking
values (4, '2019-07-22 12:30:00', 3, 0, 2, 'a_open', 7, 120, 295);

insert into Dive
values (4, 3, true),
	(4, 1, false),
	(4, 0, false),
	(4, 2, false),
	(4, 4, false),
	(4, 6, false),
	(4, 5, false);

insert into MonitorRating
values (0, 1, 3);

update Monitor
set avg_rating = ((select coalesce(sum(rating), 0) from MonitorRating where monitor_id = 0)::float / (select coalesce(count(rating), 1) from MonitorRating where monitor_id = 0)::float)
where id = 0;

insert into MonitorPrivPrice
values (2, 3, false, 50, 50, 50, 50, 50, 50, 50, 50, 50);

insert into Booking
values (5, '2019-07-23 09:30:00', 3, 2, 3, 'm_cave', 1, 65, 105),
	(6, '2019-07-24 09:30:00', 3, 2, 3, 'm_cave', 1, 65, 105);

insert into MonitorRating
values (2, 0, 3),
	(2, 2, 3);

update Monitor
set avg_rating = ((select coalesce(sum(rating), 0) from MonitorRating where monitor_id = 2)::float / (select coalesce(count(rating), 1) from MonitorRating where monitor_id = 2)::float)
where id = 2;

-- 14

update Diver
set certification = 'PADI'
where id = 3
	or id = 4;

-- auto-run views on execution of script (\i) NOTE: comment out when handing in

\d

\! echo '\n Diver'
select * from Diver order by id;
\! echo '\n Monitor'
select * from Monitor order by id;
\! echo '\n MonitorRating'
select * from MonitorRating order by monitor_id;
\! echo '\n MonitorMGS'
select * from MonitorMGS order by monitor_id, dive_type;
\! echo '\n Site'
select * from Site order by id;
\! echo '\n SiteRating'
select * from SiteRating order by site_id;
\! echo '\n SiteAddOn'
select * from SiteAddOn order by site_id;
\! echo '\n SiteService'
select * from SiteService order by site_id;
\! echo '\n MonitorPrivPrice'
select * from MonitorPrivPrice order by monitor_id, site_id;
\! echo '\n Booking'
select * from Booking order by id;
\! echo '\n Dive'
select * from Dive order by booking_id, lead desc;
