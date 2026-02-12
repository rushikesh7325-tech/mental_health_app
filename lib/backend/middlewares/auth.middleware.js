const jwt = require('jsonwebtoken');

const authenticateToken = (req, res, next) => {
    const authHeader = req.headers['authorization'];
    // Use optional chaining for safety
    const token = authHeader?.split(' ')[1]; 

    if (!token) {
        return res.status(401).json({ error: "Access denied. Token missing." });
    }

    jwt.verify(token, process.env.JWT_SECRET, (err, decoded) => {
        if (err) {
            // Check if it's specifically an expiration error
            const message = err.name === 'TokenExpiredError' 
                ? "Token expired" 
                : "Invalid token";
            return res.status(403).json({ error: message });
        }
        
        // 'decoded' contains the payload { id, type } you signed earlier
        req.user = decoded;
        next();
    });
};

module.exports = authenticateToken;