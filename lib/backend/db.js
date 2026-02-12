const { Pool } = require('pg');
const dotenv = require('dotenv');
dotenv.config();
const pool = new Pool({
    connectionString: process.env.DATABASE_URL
});

pool.query('SELECT NOW ()', (err, res) => {
    if (err) {
        console.log('Database connection failed:',err);
    } else {
        console.log("DataBase Connection Sucessfull")
    }
});
module.exports = pool;