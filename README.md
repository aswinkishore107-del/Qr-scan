# QR Scan & Store Application

A full-stack mobile and web application that allows users to scan QR codes and barcodes, store scan history, and manage data through a backend API.

## 📋 Table of Contents

- [Project Overview](#project-overview)
- [Features](#features)
- [Project Structure](#project-structure)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Configuration](#configuration)
- [Database Setup](#database-setup)
- [Running the Project](#running-the-project)
- [API Documentation](#api-documentation)
- [Troubleshooting](#troubleshooting)

## 🎯 Project Overview

This project consists of two main components:

1. **Flutter Mobile App** (`qr_flutter/`) - Cross-platform mobile application for scanning QR codes
2. **Node.js Backend** (`qr-backend/`) - Express.js API server with MySQL database

The mobile app communicates with the backend API to store and retrieve scan history.

## ✨ Features

### Mobile App (Flutter)
- 📱 Real-time QR code and barcode scanning
- 📊 Scan history with timestamps
- 🔄 Sync with backend API
- 📱 Portrait-only responsive UI
- ⚡ Fast and reliable scanning using mobile_scanner package
- 🎨 Modern Material Design 3 UI

### Backend API (Node.js)
- 🔒 CORS-enabled REST API
- 💾 MySQL database for persistent storage
- ✅ Input validation and error handling
- 📝 Request logging for debugging
- 🚀 Easy deployment

## 📁 Project Structure

```
QR-Project/
├── qr_flutter/                    # Flutter mobile app
│   ├── lib/
│   │   ├── main.dart              # App entry point
│   │   ├── screens/
│   │   │   ├── scanner_screen.dart
│   │   │   └── history_screen.dart
│   │   ├── services/
│   │   │   └── api_service.dart
│   │   └── widgets/
│   │       └── scan_result_card.dart
│   ├── pubspec.yaml               # Flutter dependencies
│   └── ...platform files
│
├── qr-backend/                    # Node.js backend
│   ├── config/
│   │   ├── db.js                  # Database configuration
│   │   └── init.sql               # Database schema
│   ├── controllers/
│   │   └── scanController.js
│   ├── models/
│   │   └── scanModel.js
│   ├── routes/
│   │   └── scanRoutes.js
│   ├── middleware/
│   │   └── errorHandler.js
│   ├── server.js                  # Express app entry point
│   ├── package.json               # Node.js dependencies
│   └── .env                       # Environment variables
│
└── README.md                       # This file
```

## 📦 Prerequisites

Before you begin, make sure you have installed:

### For Backend
- **Node.js** (v14 or higher) - [Download](https://nodejs.org/)
- **npm** (comes with Node.js)
- **MySQL** (v5.7 or higher) - [Download](https://dev.mysql.com/downloads/mysql/)

### For Frontend (Flutter)
- **Flutter SDK** (v3.0.0 or higher) - [Download](https://flutter.dev/docs/get-started/install)
- **Dart** (comes with Flutter)
- **Android Studio** or **Xcode** (for mobile emulation)

### Verify Installations

```bash
# Check Node.js and npm
node --version
npm --version

# Check Flutter and Dart
flutter --version
dart --version

# Check MySQL (on command line)
mysql --version
```

## 🚀 Installation

### Step 1: Clone or Download the Project

```bash
# Navigate to your projects directory
cd path/to/QR-Project
```

### Step 2: Backend Setup

#### Install Backend Dependencies

```bash
cd qr-backend
npm install
```

This installs the following packages:
- **express** - Web framework
- **cors** - Cross-origin resource sharing
- **mysql2** - MySQL database driver
- **dotenv** - Environment variable management
- **nodemon** - Development tool (auto-reload)

#### Step 3: Frontend Setup

#### Install Flutter Dependencies

```bash
cd qr_flutter
flutter pub get
```

This installs:
- **mobile_scanner** - QR code scanning library
- **http** - HTTP client for API calls
- **intl** - Date/time formatting

## ⚙️ Configuration

### Backend Configuration

Create a `.env` file in the `qr-backend/` directory:

```bash
# qr-backend/.env
PORT=3000
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=your_mysql_password
DB_NAME=qr_scan_db
NODE_ENV=development
```

**Environment Variables Explanation:**
- `PORT` - Server port (default: 3000)
- `DB_HOST` - MySQL server hostname
- `DB_USER` - MySQL username
- `DB_PASSWORD` - MySQL password
- `DB_NAME` - Database name
- `NODE_ENV` - Environment mode (development/production)

### Frontend Configuration

The Flutter app endpoints are configured in `lib/services/api_service.dart`. Update the API base URL if needed:

```dart
const String baseUrl = 'http://your-backend-ip:3000/api';
```

For Android emulator, use: `http://10.0.2.2:3000/api`  
For iOS simulator, use: `http://localhost:3000/api`

## 💾 Database Setup

### Step 1: Start MySQL Server

```bash
# On Windows (if installed as service)
# MySQL should start automatically

# Or manually start MySQL
mysql -u root -p

# On macOS
brew services start mysql

# On Linux
sudo service mysql start
```

### Step 2: Create Database and Tables

```bash
# Open MySQL command line
mysql -u root -p

# MySQL will prompt for password, enter your password
```

Then run the SQL from `qr-backend/config/init.sql`:

```sql
-- Create the database
CREATE DATABASE IF NOT EXISTS qr_scan_db;

-- Use the database
USE qr_scan_db;

-- Create the scans table
CREATE TABLE IF NOT EXISTS scans (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  scanned_text TEXT NOT NULL,
  scanned_type VARCHAR(20) DEFAULT 'text',
  scanned_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

Or use MySQL Workbench:
1. Open MySQL Workbench
2. Open a new query tab
3. Copy the SQL from `qr-backend/config/init.sql`
4. Execute the query

## ▶️ Running the Project

### Option 1: Run Both Frontend and Backend (Recommended)

**Terminal 1 - Start Backend API:**

```bash
cd qr-backend
npm start
```

Expected output:
```
✅ Database connection successful
🚀 Server running on http://localhost:3000
📊 http://localhost:3000/health - API Health Check
```

**Terminal 2 - Start Flutter App:**

```bash
cd qr_flutter

# Run on Android emulator
flutter run -d emulator-5554

# Run on iOS simulator
flutter run -d iphone

# List available devices
flutter devices

# Run with verbose logging
flutter run -v
```

### Option 2: Run Backend with Auto-Reload (Development)

```bash
cd qr-backend
npm run dev
```

This uses **nodemon** to automatically restart the server on file changes.

### Option 3: Debug Flutter App

```bash
cd qr_flutter
flutter run --debug
```

Or with verbose output:

```bash
flutter run -v --debug
```

## 📡 API Documentation

### Base URL
```
http://localhost:3000/api
```

### Endpoints

#### 1. Get All Scans
```http
GET /api/scans
```

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "scanned_text": "https://example.com",
      "scanned_type": "URL",
      "scanned_at": "2024-04-03T10:30:00.000Z"
    }
  ]
}
```

#### 2. Create New Scan
```http
POST /api/scans
Content-Type: application/json

{
  "scanned_text": "https://example.com",
  "scanned_type": "URL"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Scan saved successfully",
  "data": {
    "id": 1,
    "scanned_text": "https://example.com"
  }
}
```

#### 3. Get Scan by ID
```http
GET /api/scans/:id
```

**Response:**
```json
{
  "success": true,
  "data": {
    "id": 1,
    "scanned_text": "https://example.com",
    "scanned_type": "URL",
    "scanned_at": "2024-04-03T10:30:00.000Z"
  }
}
```

#### 4. Delete Scan
```http
DELETE /api/scans/:id
```

**Response:**
```json
{
  "success": true,
  "message": "Scan deleted successfully"
}
```

#### 5. Health Check
```http
GET /
```

**Response:**
```json
{
  "status": "ok",
  "message": "QR Scan API is running"
}
```

## 🐛 Troubleshooting

### Backend Issues

#### Port 3000 Already in Use
```bash
# Find process using port 3000
netstat -ano | findstr :3000  # Windows
lsof -i :3000                 # macOS/Linux

# Kill the process (Windows)
taskkill /PID <PID> /F

# Kill the process (macOS/Linux)
kill -9 <PID>
```

#### Database Connection Failed
```bash
# Check if MySQL is running
mysql -u root -p -e "SELECT 1"

# Verify credentials in .env file
# Check MySQL user exists
mysql -u root -p
SHOW DATABASES;
USE mysql;
SELECT user FROM user;
```

#### Dependencies Not Installed
```bash
cd qr-backend
rm -rf node_modules package-lock.json
npm install
```

### Frontend Issues

#### Flutter App Can't Connect to Backend
- Ensure backend is running on `http://localhost:3000`
- For Android emulator, use `http://10.0.2.2:3000/api`
- Check firewall settings
- Verify API URL in `lib/services/api_service.dart`

#### Mobile Scanner Permission Denied
- **Android**: Check `android/app/src/main/AndroidManifest.xml` for camera permissions
- **iOS**: Check `ios/Runner/Info.plist` for camera usage description

#### Flutter Pub Get Fails
```bash
cd qr_flutter
flutter clean
flutter pub cache repair
flutter pub get
```

#### Emulator Won't Start
```bash
# List available AVDs
emulator -list-avds

# Delete broken emulator
emulator -avd <name> -wipe-data

# Start specific emulator
emulator -avd <name>
```

## 📚 Additional Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Express.js Documentation](https://expressjs.com/)
- [MySQL Documentation](https://dev.mysql.com/doc/)
- [Mobile Scanner Package](https://pub.dev/packages/mobile_scanner)
- [HTTP Package Documentation](https://pub.dev/packages/http)

## 📝 License

This project is open source and available under the MIT License.

## 💡 Tips for Development

1. **Enable Debug Logging**: Set `logRequests = true` in backend middleware
2. **Use Postman**: Test API endpoints before implementing in Flutter
3. **Database Backups**: Regularly backup your MySQL database
4. **Git Tracking**: Add `.env` to `.gitignore` to keep credentials safe
5. **Phone Testing**: Test on actual devices for better QR scanning performance

## 🤝 Support

For issues or questions:
1. Check the [Troubleshooting](#troubleshooting) section
2. Review error logs in the terminal
3. Check MySQL connection settings
4. Verify all prerequisites are installed correctly

---

**Happy Scanning! 📱✨**# Qr-scan
