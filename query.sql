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
