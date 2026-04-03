// routes/scanRoutes.js
const express = require('express');
const router = express.Router();
const { storeScan, getScans } = require('../controllers/scanController');

// POST /scan  → store scanned QR data
router.post('/scan', storeScan);

// GET /scans  → retrieve all scanned records
router.get('/scans', getScans);

module.exports = router;