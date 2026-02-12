const db = require('../db');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

/**
 * Helper function to generate JWT
 * Payload contains the user ID to identify them in future requests
 */
const generateToken = (userId) => {
    return jwt.sign({ id: userId }, process.env.JWT_SECRET, { expiresIn: '24h' });
};

const registerUser = async (req, res) => {
    const {
        full_name, email, password, phone_number,
        user_type, university_name, company_name, role, org_code
    } = req.body;

    // Validate JWT_SECRET exists before starting heavy DB operations
    if (!process.env.JWT_SECRET) {
        return res.status(500).json({ error: "Server configuration error: JWT_SECRET missing" });
    }

    const client = await db.connect();

    try {
        await client.query('BEGIN');

        // 1. Hash Password
        const saltRounds = 10;
        const passwordHash = await bcrypt.hash(password, saltRounds);

        // 2. Insert into users
        const userResult = await client.query(
            `INSERT INTO users (full_name, email, phone_number, password_hash, user_type) 
             VALUES ($1, $2, $3, $4, $5) RETURNING id, full_name, email, user_type`,
            [full_name, email, phone_number, passwordHash, user_type]
        );

        const newUser = userResult.rows[0];

        // 3. Insert into profiles based on user_type
        if (user_type === 'university') {
            await client.query(
                `INSERT INTO university_profiles (user_id, university_name) VALUES ($1, $2)`,
                [newUser.id, university_name]
            );
        } else if (user_type === 'company') {
            await client.query(
                `INSERT INTO company_profiles (user_id, company_name, role, org_code) VALUES ($1, $2, $3, $4)`,
                [newUser.id, company_name, role, org_code]
            );
        }

        // 4. Generate Token for the new user
        const token = generateToken(newUser.id);

        await client.query('COMMIT');

        // Return BOTH user info and the token
        res.status(201).json({
            message: "User registered successfully",
            token,
            user: newUser
        });

    } catch (error) {
        await client.query('ROLLBACK');
        console.error("Registration Error:", error.message);

        // Check for unique constraint violation (email already exists)
        if (error.code === '23505') {
            return res.status(409).json({ error: "Email address is already registered" });
        }

        res.status(500).json({ error: "Internal server error" });
    } finally {
        client.release();
    }
};




const loginUser = async (req, res) => {
    const { email, password } = req.body;

    try {
        // 1. Find user in PostgreSQL
        const userResult = await db.query('SELECT * FROM users WHERE email = $1', [email]);
        const user = userResult.rows[0];
        if (!user) return res.status(401).json({ error: "Invalid credentials" });

        // 2. Compare passwords
        const isMatch = await bcrypt.compare(password, user.password_hash);
        if (!isMatch) return res.status(401).json({ error: "Invalid credentials" });

        // 3. Generate JWT
        const token = jwt.sign(
            { id: user.id, type: user.user_type },
            process.env.JWT_SECRET,
            { expiresIn: '24h' }
        );

        res.json({ token, user: { id: user.id, email: user.email } });
    } catch (err) {
        res.status(500).json({ error: "Server error" });
    }
};
const updateGoals = async (req, res) => {
    const { goals } = req.body;
    const userId = req.user.id; // Extracted by authenticateToken middleware

    if (!goals || goals.length !== 3) {
        return res.status(400).json({ error: "Select 3 goals" });
    }

    const client = await db.connect();
    try {
        await client.query(
            "UPDATE users SET primary_goals = $1 WHERE id = $2",
            [goals, userId]
        );
        res.status(200).json({ message: "Goals updated successfully" });
    } catch (error) {
        console.error("Backend Error:", error);
        res.status(500).json({ error: "Internal server error" });
    } finally {
        client.release();
    }
};



module.exports = { registerUser, loginUser,updateGoals };