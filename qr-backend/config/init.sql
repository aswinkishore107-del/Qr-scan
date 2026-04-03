-- Run this SQL in MySQL Workbench to set up the database

-- Step 1: Create the database
CREATE DATABASE IF NOT EXISTS qr_scan_db;

-- Step 2: Use the database
USE qr_scan_db;

-- Step 3: Create the scans table
CREATE TABLE IF NOT EXISTS scans (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  scanned_text TEXT NOT NULL,
  scanned_type VARCHAR(20) DEFAULT 'text',
  scanned_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Optional: View all records
-- SELECT * FROM scans ORDER BY scanned_at DESC;