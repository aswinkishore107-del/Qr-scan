// server.js
require('dotenv').config();
const express = require('express');
const cors = require('cors');

const scanRoutes = require('./routes/scanRoutes');
const { validateScanInput, globalErrorHandler } = require('./middleware/errorHandler');

const app = express();
const PORT = process.env.PORT || 3000;

// ─── Middleware ───────────────────────────────────────────────
app.use(cors());                          // Allow cross-origin (Flutter app)
app.use(express.json());                  // Parse JSON request bodies
app.use(express.urlencoded({ extended: true }));

// ─── Request Logger (for debugging) ──────────────────────────
app.use((req, res, next) => {
  const time = new Date().toLocaleTimeString();
  console.log(`\n📨 [${time}] ${req.method} ${req.url}`);
  if (req.method === 'POST') {
    console.log(`   Body:`, JSON.stringify(req.body));
  }
  next();
});

app.use(validateScanInput);               // Validate incoming requests

// ─── Health Check ─────────────────────────────────────────────
app.get('/', (req, res) => {
  res.json({
    success: true,
    message: '🚀 QR Scan & Store API is running.',
    endpoints: {
      storeScan: 'POST /scan',
      getScans:  'GET  /scans',
    },
  });
});

// ─── Routes ───────────────────────────────────────────────────
app.use('/', scanRoutes);

// ─── 404 Handler ──────────────────────────────────────────────
app.use((req, res) => {
  res.status(404).json({ success: false, message: 'Route not found.' });
});

// ─── Global Error Handler ─────────────────────────────────────
app.use(globalErrorHandler);

// ─── Start Server ─────────────────────────────────────────────
app.listen(PORT, '0.0.0.0', () => {
  console.log(`\n🚀 Server running at http://0.0.0.0:${PORT}`);
  console.log(`   Accessible at: http://10.253.189.247:${PORT}`);
  console.log(`   POST /scan  → Store a QR scan`);
  console.log(`   GET  /scans → Retrieve all scans\n`);
});