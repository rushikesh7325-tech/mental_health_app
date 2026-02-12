const express = require('express');
const router = express.Router();
const authenticateToken = require('../middlewares/auth.middleware');
const { saveUniversityAssessment } = require('../controllers/uni_assement.controller');

// Matches: POST http://localhost:5000/api/university/submit
router.post('/unisubmit', authenticateToken, saveUniversityAssessment);

module.exports = router;