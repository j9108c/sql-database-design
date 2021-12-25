\! echo '\n\n\n\n\n'

-- wetworld dive booking schema

	-- constraints which could not be enforced::
		-- "divers must be at least 16 when a dive occurs"
			-- as per the specifications in the handout, we cant use assertions or triggers for cross-table checking
		-- "no monitor is allowed to book more than two dives per 24 hour period"
			-- could not be enforced because PSQL doesn't support subqueries in check constraint

drop schema if exists wetworldschema cascade;
create schema wetworldschema;
set search_path to wetworldschema;

create table Diver ( -- divers
	id int primary key,
	name varchar(50) not null,
	age int not null,
	certification varchar(4) not null,
	credit_card int not null,
	email varchar(50) not null,

	check (age >= 16),
	check (certification = 'NAUI'
		or certification = 'CMAS'
		or certification = 'PADI')
);

create table Monitor ( -- monitors
	id int primary key,
	name varchar(50) not null,
	avg_rating float,
	take_limit int not null,
	email varchar(50) not null,

	check (avg_rating >= 0
		and avg_rating <= 5),
	check (take_limit >= 1)
);

create table MonitorRating ( -- monitor ratings
	monitor_id int not null references Monitor,
	rating int not null,
	rater_id int not null references Diver

	check (rating >= 0
		and rating <= 5)
);

create table MonitorMGS ( -- monitor max group sizes 
	monitor_id int not null references Monitor,
	dive_type varchar(4) not null,
	mgs int not null,

	unique (monitor_id, dive_type),
	check (dive_type = 'open' -- open water dive
		or dive_type = 'cave' -- cave dive
		or dive_type = 'deep'), -- beyond 30m dive
	check (mgs >= 0)
);

create table Site ( -- dive sites
	id int primary key,
	name varchar(100) not null,
	avg_rating float,
	has_open boolean not null,
	has_cave boolean not null,
	has_deep boolean not null,
	cap_day int not null,
	cap_night int not null,
	cap_cave int not null,
	cap_deep int not null,
	charge money not null, -- per-diver charge (w/o add-ons) by site

	check (avg_rating >= 0
		and avg_rating <= 5),
	check (cap_day > cap_night
		and cap_day > cap_cave
		and cap_day > cap_deep)
);

create table SiteRating ( -- dive site ratings
	site_id int not null references Site,
	rating int not null,
	rater_id int not null references Diver,

	check (rating >= 0
		and rating <= 5)
);

create table SiteAddOn ( -- dive site add-ons
	site_id int primary key references Site,
	p_tank money not null, -- p for price
	p_belt money not null,
	p_vest money not null,
	p_mask money,
	p_reg money,
	p_fin money,
	p_comp money
);

create table SiteService ( -- dive site free services
	site_id int primary key references Site,
	has_video boolean not null,
	has_snack boolean not null,
	has_shower boolean not null,
	has_towel boolean not null
);

create table MonitorPrivPrice ( -- monitor privilege and price
	monitor_id int not null references Monitor,
	site_id int not null references Site,
	privilege boolean not null,
	p_m_open money, -- m for morning (9:30am - 11am)
	p_m_cave money,
	p_m_deep money,
	p_a_open money, -- a for afternoon (12:30pm - 2pm)
	p_a_cave money,
	p_a_deep money,
	p_n_open money, -- n for night (8:30pm - 10pm)
	p_n_cave money,
	p_n_deep money,

	unique (monitor_id, site_id)
);

create table Booking ( -- dive bookings
	id int primary key,
	dive_at timestamp not null,
	lead_id int not null references Diver, -- lead diver who booked this dive
	monitor_id int not null references Monitor,
	site_id int not null references Site,
	tod_type varchar(6) not null, -- time of day and dive type
	num_divers int not null, -- does not incl monitor
	base_charge money not null, -- base price (monitor price + site per-diver charge) charged by monitor
	max_charge money not null, -- max possible charge (base charge + all possible extra site add-ons)

	unique (dive_at, lead_id),
	unique (dive_at, monitor_id),
	check (tod_type = 'm_open'
		or tod_type = 'm_cave'
		or tod_type = 'm_deep'
		or tod_type = 'a_open'
		or tod_type = 'a_cave'
		or tod_type = 'a_deep'
		or tod_type = 'n_open'
		or tod_type = 'n_cave'
		or tod_type = 'n_deep'),
	check (num_divers >= 1)
);

create table Dive ( -- actual dives
	booking_id int not null references Booking,
	diver_id int not null references Diver,
	lead boolean not null, -- lead diver

	unique (booking_id, diver_id)
);

-- auto-run views on execution of schema (\i) NOTE: comment out when handing in

\d

\! echo '\n Diver'
select * from Diver;
\! echo '\n Monitor'
select * from Monitor;
\! echo '\n MonitorRating'
select * from MonitorRating;
\! echo '\n MonitorMGS'
select * from MonitorMGS;
\! echo '\n Site'
select * from Site;
\! echo '\n SiteRating'
select * from SiteRating;
\! echo '\n SiteAddOn'
select * from SiteAddOn;
\! echo '\n SiteService'
select * from SiteService;
\! echo '\n MonitorPrivPrice'
select * from MonitorPrivPrice;
\! echo '\n Booking'
select * from Booking;
\! echo '\n Dive'
select * from Dive;

\i data.sql
