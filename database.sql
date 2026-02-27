-- Hotel Booking System - MySQL Schema
-- DBMS College Project

CREATE DATABASE IF NOT EXISTS hotel_booking_db;
USE hotel_booking_db;


-- TABLE: Guest
CREATE TABLE Guest (
    guest_id    INT AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(100) NOT NULL,
    email       VARCHAR(100) UNIQUE NOT NULL,
    phone       VARCHAR(15),
    address     TEXT,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- TABLE: Hotel
CREATE TABLE Hotel (
    hotel_id    INT AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(150) NOT NULL,
    location    VARCHAR(200) NOT NULL,
    star_rating TINYINT CHECK (star_rating BETWEEN 1 AND 5),
    description TEXT,
    phone       VARCHAR(15),
    email       VARCHAR(100)
);

-- TABLE: Room
CREATE TABLE Room (
    room_id             INT AUTO_INCREMENT PRIMARY KEY,
    hotel_id            INT NOT NULL,
    room_number         VARCHAR(10) NOT NULL,
    room_type           ENUM('Single', 'Double', 'Suite', 'Deluxe', 'Twin') NOT NULL,
    price               DECIMAL(10, 2) NOT NULL,
    availability_status ENUM('Available', 'Occupied', 'Maintenance') DEFAULT 'Available',
    capacity            INT DEFAULT 1,
    amenities           TEXT,
    FOREIGN KEY (hotel_id) REFERENCES Hotel(hotel_id) ON DELETE CASCADE
);

-- TABLE: Booking / Reservation
CREATE TABLE Booking (
    booking_id      INT AUTO_INCREMENT PRIMARY KEY,
    guest_id        INT NOT NULL,
    room_id         INT NOT NULL,
    check_in_date   DATE NOT NULL,
    check_out_date  DATE NOT NULL,
    total_price     DECIMAL(10, 2) NOT NULL,
    booking_status  ENUM('Confirmed', 'Pending', 'Cancelled', 'Completed') DEFAULT 'Pending',
    booked_at       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    special_requests TEXT,
    FOREIGN KEY (guest_id) REFERENCES Guest(guest_id) ON DELETE CASCADE,
    FOREIGN KEY (room_id)  REFERENCES Room(room_id)   ON DELETE CASCADE,
    CHECK (check_out_date > check_in_date)
);

-- TABLE: Payment
CREATE TABLE Payment (
    payment_id      INT AUTO_INCREMENT PRIMARY KEY,
    booking_id      INT NOT NULL,
    amount_paid     DECIMAL(10, 2) NOT NULL,
    payment_date    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_method  ENUM('Cash', 'Credit Card', 'Debit Card', 'UPI', 'Bank Transfer') NOT NULL,
    payment_status  ENUM('Paid', 'Pending', 'Refunded', 'Failed') DEFAULT 'Pending',
    transaction_id  VARCHAR(100),
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id) ON DELETE CASCADE
);

-- SAMPLE DATA
-- Hotels
INSERT INTO Hotel (name, location, star_rating, description, phone, email) VALUES
('The Grand Palace', 'Mumbai, Maharashtra', 5, 'A luxurious 5-star experience in the heart of Mumbai.', '022-12345678', 'info@grandpalace.com'),
('Sunset Inn', 'Goa, India', 3, 'Cozy beachside inn with stunning sunset views.', '0832-9876543', 'stay@sunsetinn.com'),
('City Central Hotel', 'Bangalore, Karnataka', 4, 'Modern hotel at the center of the city.', '080-11223344', 'hello@citycentral.com');
select * from Hotel;

-- Rooms
INSERT INTO Room (hotel_id, room_number, room_type, price, availability_status, capacity, amenities) VALUES
(1, '101', 'Single',  2500.00, 'Available', 1, 'AC, WiFi, TV'),
(1, '102', 'Double',  4500.00, 'Available', 2, 'AC, WiFi, TV, Mini Fridge'),
(1, '201', 'Suite',   12000.00,'Available', 3, 'AC, WiFi, TV, Jacuzzi, King Bed'),
(2, '01',  'Single',  1500.00, 'Available', 1, 'Fan, WiFi, Beach View'),
(2, '02',  'Double',  2800.00, 'Available', 2, 'AC, WiFi, Beach View'),
(3, 'A1',  'Deluxe',  6000.00, 'Available', 2, 'AC, WiFi, TV, City View'),
(3, 'A2',  'Twin',    3500.00, 'Available', 2, 'AC, WiFi, Twin Beds');

-- Guests
INSERT INTO Guest (name, email, phone, address) VALUES
('Rahul Sharma',   'rahul@example.com',  '9876543210', 'Delhi, India'),
('Priya Patel',    'priya@example.com',  '9123456789', 'Ahmedabad, Gujarat'),
('Arjun Mehta',    'arjun@example.com',  '9988776655', 'Pune, Maharashtra'),
('Sneha Reddy',    'sneha@example.com',  '9001122334', 'Hyderabad, Telangana');

-- Bookings
INSERT INTO Booking (guest_id, room_id, check_in_date, check_out_date, total_price, booking_status) VALUES
(1, 1, '2025-03-01', '2025-03-03', 5000.00,  'Confirmed'),
(2, 5, '2025-03-05', '2025-03-07', 5600.00,  'Confirmed'),
(3, 6, '2025-03-10', '2025-03-12', 12000.00, 'Pending'),
(4, 3, '2025-03-15', '2025-03-18', 36000.00, 'Confirmed');

-- Payments
INSERT INTO Payment (booking_id, amount_paid, payment_method, payment_status, transaction_id) VALUES
(1, 5000.00,  'UPI',         'Paid',    'TXN001ABC'),
(2, 5600.00,  'Credit Card', 'Paid',    'TXN002DEF'),
(3, 0.00,     'Cash',        'Pending', NULL),
(4, 36000.00, 'Debit Card',  'Paid',    'TXN004GHI');

-- USEFUL QUERIES

-- 1. View all bookings with guest and room info
SELECT 
    b.booking_id,
    g.name AS guest_name,
    g.email,
    h.name AS hotel_name,
    r.room_number,
    r.room_type,
    b.check_in_date,
    b.check_out_date,
    b.total_price,
    b.booking_status
FROM Booking b
JOIN Guest g ON b.guest_id = g.guest_id
JOIN Room r  ON b.room_id  = r.room_id
JOIN Hotel h ON r.hotel_id = h.hotel_id;

-- 2. Available rooms
SELECT r.room_id, h.name AS hotel, r.room_number, r.room_type, r.price
FROM Room r
JOIN Hotel h ON r.hotel_id = h.hotel_id
WHERE r.availability_status = 'Available';

-- 3. Revenue per hotel
SELECT h.name AS hotel, SUM(p.amount_paid) AS total_revenue
FROM Payment p
JOIN Booking b ON p.booking_id = b.booking_id
JOIN Room r    ON b.room_id    = r.room_id
JOIN Hotel h   ON r.hotel_id   = h.hotel_id
WHERE p.payment_status = 'Paid'
GROUP BY h.hotel_id;

-- 4. Guest booking history
SELECT g.name, b.booking_id, b.check_in_date, b.check_out_date, b.total_price, b.booking_status
FROM Guest g
JOIN Booking b ON g.guest_id = b.guest_id
ORDER BY b.booked_at DESC;

-- 5. Cancel a booking and update room status
-- UPDATE Booking SET booking_status = 'Cancelled' WHERE booking_id = 3;
-- UPDATE Room SET availability_status = 'Available' WHERE room_id = (SELECT room_id FROM Booking WHERE booking_id = 3);