// models/scanModel.js
const db = require('../config/db');

const ScanModel = {
  // Insert a new scan record
  async createScan(scannedText, scannedType = 'text') {
    const sql = 'INSERT INTO scans (scanned_text, scanned_type) VALUES (?, ?)';
    const [result] = await db.execute(sql, [scannedText, scannedType]);
    return result;
  },

  // Retrieve all scans, newest first
  async getAllScans() {
    const sql = 'SELECT * FROM scans ORDER BY scanned_at DESC';
    const [rows] = await db.execute(sql);
    return rows;
  },

  // Retrieve a single scan by ID
  async getScanById(id) {
    const sql = 'SELECT * FROM scans WHERE id = ?';
    const [rows] = await db.execute(sql, [id]);
    return rows[0];
  },
};

module.exports = ScanModel;