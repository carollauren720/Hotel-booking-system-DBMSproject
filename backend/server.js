require('dotenv').config();
const express = require('express');
const mysql   = require('mysql2');
const cors    = require('cors');
const path    = require('path');

const app = express();
app.use(cors());
app.use(express.json());
app.use(express.static(path.join(__dirname)));

//Database Connection 
const db = mysql.createConnection({
    host:     process.env.DB_HOST,
    user:     process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME
});

db.connect(err => {
    if (err) {
        console.error('❌ DB connection failed:', err.message);
    } else {
        console.log('✅ Connected to MySQL!');
    }
});

//GET Routes 

app.get('/api/guests', (req, res) => {
    db.query('SELECT * FROM Guest', (err, rows) => {
        if (err) return res.json({ error: err.message });
        res.json(rows);
    });
});

app.get('/api/rooms', (req, res) => {
    db.query('SELECT * FROM Room', (err, rows) => {
        if (err) return res.json({ error: err.message });
        res.json(rows);
    });
});

app.get('/api/bookings', (req, res) => {
    db.query('SELECT * FROM Booking', (err, rows) => {
        if (err) return res.json({ error: err.message });
        res.json(rows);
    });
});

app.get('/api/payments', (req, res) => {
    db.query('SELECT * FROM Payment', (err, rows) => {
        if (err) return res.json({ error: err.message });
        res.json(rows);
    });
});

//POST Routes 

app.post('/api/guests', (req, res) => {
    const { name, email, phone, address } = req.body;
    if (!name || !email) return res.json({ error: 'Name and email required' });
    db.query(
        'INSERT INTO Guest (name, email, phone, address) VALUES (?, ?, ?, ?)',
        [name, email, phone, address],
        (err, result) => {
            if (err) return res.json({ error: err.message });
            res.json({ success: true, id: result.insertId });
        }
    );
});

app.post('/api/bookings', (req, res) => {
    const { guest_id, room_id, check_in_date, check_out_date, total_price, booking_status, special_requests } = req.body;
    db.query(
        'INSERT INTO Booking (guest_id, room_id, check_in_date, check_out_date, total_price, booking_status, special_requests) VALUES (?, ?, ?, ?, ?, ?, ?)',
        [guest_id, room_id, check_in_date, check_out_date, total_price, booking_status, special_requests],
        (err, result) => {
            if (err) return res.json({ error: err.message });
            db.query("UPDATE Room SET availability_status='Occupied' WHERE room_id=?", [room_id]);
            res.json({ success: true, id: result.insertId });
        }
    );
});

app.post('/api/payments', (req, res) => {
    const { booking_id, amount_paid, payment_method, payment_status, transaction_id } = req.body;
    db.query(
        'INSERT INTO Payment (booking_id, amount_paid, payment_method, payment_status, transaction_id) VALUES (?, ?, ?, ?, ?)',
        [booking_id, amount_paid, payment_method, payment_status, transaction_id],
        (err, result) => {
            if (err) return res.json({ error: err.message });
            res.json({ success: true, id: result.insertId });
        }
    );
});

//PATCH Routes 

app.patch('/api/bookings/:id/cancel', (req, res) => {
    const id = req.params.id;
    db.query('SELECT room_id FROM Booking WHERE booking_id=?', [id], (err, rows) => {
        if (err || !rows.length) return res.json({ error: 'Booking not found' });
        const room_id = rows[0].room_id;
        db.query("UPDATE Booking SET booking_status='Cancelled' WHERE booking_id=?", [id]);
        db.query("UPDATE Room SET availability_status='Available' WHERE room_id=?", [room_id]);
        res.json({ success: true });
    });
});

app.patch('/api/bookings/:id/complete', (req, res) => {
    const id = req.params.id;
    db.query('SELECT room_id FROM Booking WHERE booking_id=?', [id], (err, rows) => {
        if (err || !rows.length) return res.json({ error: 'Booking not found' });
        const room_id = rows[0].room_id;
        db.query("UPDATE Booking SET booking_status='Completed' WHERE booking_id=?", [id]);
        db.query("UPDATE Room SET availability_status='Available' WHERE room_id=?", [room_id]);
        res.json({ success: true });
    });
});

app.patch('/api/rooms/:id/status', (req, res) => {
    const { status } = req.body;
    db.query('UPDATE Room SET availability_status=? WHERE room_id=?', [status, req.params.id], (err) => {
        if (err) return res.json({ error: err.message });
        res.json({ success: true });
    });
});

//DELETE Routes

app.delete('/api/guests/:id', (req, res) => {
    db.query('DELETE FROM Guest WHERE guest_id=?', [req.params.id], (err) => {
        if (err) return res.json({ error: err.message });
        res.json({ success: true });
    });
});

app.delete('/api/rooms/:id', (req, res) => {
    db.query('DELETE FROM Room WHERE room_id=?', [req.params.id], (err) => {
        if (err) return res.json({ error: err.message });
        res.json({ success: true });
    });
});

//Start Server
app.listen(process.env.PORT, () => {
    console.log(`🏨 Hotel server running at http://localhost:${process.env.PORT}`);
});