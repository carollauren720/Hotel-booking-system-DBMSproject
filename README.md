LuxeStay — Hotel Booking & Management System

A full-stack hotel booking and management system built for a college DBMS project using MySQL, Node.js, Express, and vanilla HTML/CSS/JS.


📸 Screenshots

Replace the image paths below with your actual screenshots after taking them.

Dashboard
Show Image
Rooms
Show Image
Bookings
Show Image
Payments
Show Image

📋 Table of Contents

Features
Tech Stack
Database Schema
Project Structure
Getting Started
API Endpoints
How to Use


✨ Features

Dashboard — Live stats for guests, rooms, bookings and revenue
Guest Management — Add, search and delete guests
Room Inventory — Manage rooms across multiple hotels with status tracking
Booking System — Create reservations with automatic price calculation
Payment Tracking — Record and monitor all transactions
SQL Schema Viewer — View ER relationships and key queries inside the app


🛠 Tech Stack
LayerTechnologyFrontendHTML, CSS, JavaScriptBackendNode.js, Express.jsDatabaseMySQLToolsMySQL Workbench, VS Code

🗄 Database Schema
The system uses 5 interconnected tables:
Guest ──────────────┐
                    ▼
Hotel ──► Room ──► Booking ──► Payment
TablePrimary KeyDescriptionGuestguest_idStores customer informationHotelhotel_idHotel property detailsRoomroom_idRoom inventory per hotelBookingbooking_idReservation recordsPaymentpayment_idTransaction records

📁 Project Structure
hotel-backend/
├── hotel_booking.html    # Frontend UI
├── server.js             # Express backend + API routes
├── .env                  # Environment variables (not pushed to GitHub)
├── .gitignore
├── package.json
├── node_modules/
└── screenshots/          # Add your screenshots here
    ├── dashboard.png
    ├── rooms.png
    ├── bookings.png
    └── payments.png

🚀 Getting Started
Prerequisites

Node.js installed
MySQL installed
MySQL Workbench (optional, for GUI)

1. Clone the Repository
bashgit clone https://github.com/your-username/hotel-backend.git
cd hotel-backend
2. Install Dependencies
bashnpm install
3. Set Up the Database
Open MySQL Workbench and import the schema:

Go to Server → Data Import
Select Import from Self-Contained File
Choose hotel_schema.sql
Set target schema to hotel_booking_db
Click Start Import

4. Configure Environment Variables
Create a .env file in the root folder:
envPORT=3000
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=your_mysql_password
DB_NAME=hotel_booking_db
5. Start the Server
bashnode server.js
You should see:
✅ Connected to MySQL!
🏨 Hotel server running at http://localhost:3000
6. Open the App
Go to your browser and visit:
http://localhost:3000/hotel_booking.html

📡 API Endpoints
Guests
MethodEndpointDescriptionGET/api/guestsGet all guestsPOST/api/guestsAdd a new guestDELETE/api/guests/:idDelete a guest
Rooms
MethodEndpointDescriptionGET/api/roomsGet all roomsPOST/api/roomsAdd a new roomPATCH/api/rooms/:id/statusUpdate room statusDELETE/api/rooms/:idDelete a room
Bookings
MethodEndpointDescriptionGET/api/bookingsGet all bookingsPOST/api/bookingsCreate a new bookingPATCH/api/bookings/:id/cancelCancel a bookingPATCH/api/bookings/:id/completeComplete a booking
Payments
MethodEndpointDescriptionGET/api/paymentsGet all paymentsPOST/api/paymentsRecord a payment

Made by 
CAROL LAUREN MENEZES
DBMS project-2026
