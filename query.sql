--create a new database

create database Ticket_Booking

-- create users table

create table Users (
    user_id int primary key,
    full_name varchar(100) not null,
    email varchar(100) unique not null,
    role varchar(20) not null check (role in ('Ticket Manager', 'Football Fan')),
    phone_number varchar(15)
)

-- create matches table 

create table Matches (
    match_id int primary key,
    fixture text not null,
    tournament_category varchar(150) not null,
    base_ticket_price decimal(10, 2) not null
        check(base_ticket_price >= 0),
    match_status varchar(20) not null
       check(match_status in ('Available', 'Selling Fast', 'Sold Out', 'Postponed'))
)


-- create bookings table

create table Bookings (
    booking_id int primary key,
    user_id int not null,
    match_id int not null,
    seat_number varchar(20),
    payment_status  varchar(20)
       check(payment_status in ('Pending', 'Confirmed', 'Cancelled', 'Refunded')),
    total_cost decimal(10, 2) not null
       check(total_cost >= 0),

    foreign key (user_id) references users(user_id),
    foreign key (match_id) references matches(match_id)
)

-- insert data into users table

INSERT INTO Users (user_id, full_name, email, role, phone_number) VALUES
(1, 'Tanvir Rahman', 'tanvir@mail.com', 'Football Fan', '+8801711111111'),
(2, 'Asif Haque', 'asif@mail.com', 'Football Fan', '+8801722222222'),
(3, 'Sajjad Rahman', 'sajjad@mail.com', 'Ticket Manager', '+8801733333333'),
(4, 'Jannat Ara', 'jannat@mail.com', 'Football Fan', NULL);


-- insert data into matches table

INSERT INTO Matches (match_id, fixture, tournament_category, base_ticket_price, match_status) VALUES
(101, 'Real Madrid vs Barcelona', 'Champions League', 150.00, 'Available'),
(102, 'Man City vs Liverpool', 'Premier League', 120.00, 'Selling Fast'),
(103, 'Bayern Munich vs PSG', 'Champions League', 130.00, 'Available'),
(104, 'AC Milan vs Inter Milan', 'Serie A', 90.00, 'Sold Out'),
(105, 'Juventus vs Roma', 'Serie A', 80.00, 'Available');


-- insert data into bookings table

INSERT INTO Bookings (booking_id, user_id, match_id, seat_number, payment_status, total_cost) VALUES
(501, 1, 101, 'A-12', 'Confirmed', 150.00),
(502, 1, 102, 'B-04', 'Confirmed', 120.00),
(503, 2, 101, 'A-13', 'Confirmed', 150.00),
(504, 2, 101, NULL, NULL, 150.00),
(505, 3, 102, 'C-20', 'Pending', 120.00);

-- Query 01: Retrieve all upcoming football matches belonging to the 'Champions League' where the match status is 'Available'.

select * from matches
 where tournament_category = 'Champions League' and match_status = 'Available'


-- Query 2: Search for all users whose full names start with 'Tanvir' or contain the phrase 'Haque' (case-insensitive).

select * from users
 where full_name like 'Tanvir%' or full_name like '%Haque%'


-- Query 3: Retrieve all booking records where the payment status is missing (NULL), replacing the empty result with 'Action Required'.

select 
  booking_id,
    user_id,
    match_id,
    coalesce(seat_number, 'Action Required') as seat_number,
    coalesce(payment_status, 'Action Required') as payment_status
  from bookings
 where payment_status is null or seat_number is null



-- Query 4: Retrieve match booking details along with the User's full name and the scheduled Match fixture teams.

select b.booking_id, u.full_name, m.fixture, b.total_cost from bookings b 
 inner join users u 
on u.user_id = b.user_id
  inner join matches m
on m.match_id = b.match_id


-- Query 5: Display a comprehensive list of all users and their booking IDs, ensuring that fans who have never bought a ticket are still listed.


select u.user_id, u.full_name, b.booking_id from users u  
  left join bookings b 
on u.user_id = b.user_id




-- Query 6: Find all ticket bookings where the total cost is strictly higher than the average cost of all ticket bookings.


select booking_id, match_id, total_cost from bookings
  where total_cost > (
    select avg(total_cost) from bookings
  )



-- Query 7: Retrieve the top 2 most expensive matches sorted by base ticket price, skipping the absolute highest premium match.
  

select match_id, fixture, base_ticket_price from matches 
order by base_ticket_price desc limit 2 offset 1

