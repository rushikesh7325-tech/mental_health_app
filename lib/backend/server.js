const express = require('express');
const cors = require('cors');
const dotenv = require('dotenv');
dotenv.config();
const universityRoutes = require('./routes/uni.routes'); // Add this
require('./db'); 
const userRoutes = require('./routes/user.routes');

const app = express();

// --- 1. PRE-PARSING SETUP ---
app.use(cors()); 

// --- 2. THE BODY PARSERS (Absolute Top Priority) ---
app.use(express.json()); 
app.use(express.urlencoded({ extended: true }));

// --- 3. THE HEADER CLEANER ---
// Express 5 is strict. If Flutter sends "application/json; charset=utf-8", 
// this ensures the parser recognizes it correctly.
app.use((req, res, next) => {
    if (req.headers['content-type']) {
        // Clean double headers or weird spacing
        if (req.headers['content-type'].includes(',')) {
            req.headers['content-type'] = req.headers['content-type'].split(',')[0].trim();
        }
    }
    next();
});

// --- 4. ROUTES --

// ... existing code ...

app.use('/api/user', userRoutes);
app.use('/api/university', universityRoutes); // Add this line

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
    console.log(`🚀 Server listening on Port: ${PORT}`);
});