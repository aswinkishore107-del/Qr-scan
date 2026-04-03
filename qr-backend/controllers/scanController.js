// controllers/scanController.js
const ScanModel = require('../models/scanModel');

// Helper: detect if text is a URL
function detectType(text) {
  try {
    const url = new URL(text);
    return url.protocol === 'http:' || url.protocol === 'https:' ? 'url' : 'text';
  } catch {
    return 'text';
  }
}

// POST /scan — Store a new scan
const storeScan = async (req, res, next) => {
  try {
    const { text } = req.body;

    if (!text || text.trim() === '') {
      return res.status(400).json({
        success: false,
        message: 'Scanned text is required and cannot be empty.',
      });
    }

    const scannedText = text.trim();
    const scannedType = detectType(scannedText);

    const result = await ScanModel.createScan(scannedText, scannedType);

    return res.status(201).json({
      success: true,
      message: 'Scan stored successfully.',
      data: {
        id: result.insertId,
        scanned_text: scannedText,
        scanned_type: scannedType,
      },
    });
  } catch (error) {
    next(error);
  }
};

// GET /scans — Retrieve all scans
const getScans = async (req, res, next) => {
  try {
    const scans = await ScanModel.getAllScans();

    return res.status(200).json({
      success: true,
      count: scans.length,
      data: scans,
    });
  } catch (error) {
    next(error);
  }
};

module.exports = { storeScan, getScans };