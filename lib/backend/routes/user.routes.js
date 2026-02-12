// routes/userRoutes.js
const express = require('express');
const router = express.Router();
const authenticateToken = require('../middlewares/auth.middleware');
const { loginUser, registerUser, updateGoals } = require('../controllers/user.controller');
const { saveAssessment } = require('../controllers/user_assesment.controller');
const poshController = require('../controllers/posh.controller');

// --- Auth Flow ---
router.post('/register', registerUser);
router.post('/login', loginUser);
router.put('/goals', authenticateToken, updateGoals);

// This route is protected!
router.get('/profile', authenticateToken);

// --- Wellbeing Assessment Flow ---
router.post('/assesment', authenticateToken, saveAssessment);

// --- POSH (Prevention of Sexual Harassment) Flow ---
// Extracts userId from authenticateToken to prevent impersonation

// 1. Sync training module progress (updates time spent and completion)
router.post('/posh/progress', authenticateToken, poshController.saveTrainingProgress);

// 2. Finalize digital signature and legal consent
router.post('/posh/consent', authenticateToken, poshController.finalizeConsent);

// 3. Submit the official incident report
router.post('/posh/report', authenticateToken, poshController.submitReport);
router.get('/posh/my-reports', authenticateToken, poshController.getMyReports);
router.get('/posh/status', authenticateToken, poshController.getPoshStatus);
module.exports = router;