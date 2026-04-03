// middleware/errorHandler.js

// Request body validator middleware
const validateScanInput = (req, res, next) => {
  if (req.method === 'POST' && req.path === '/scan') {
    const { text } = req.body;
    if (text === undefined) {
      return res.status(400).json({
        success: false,
        message: 'Request body must contain a "text" field.',
      });
    }
  }
  next();
};

// Global error handler
const globalErrorHandler = (err, req, res, next) => {
  console.error('❌ Server Error:', err.message);

  if (err.code === 'ER_ACCESS_DENIED_ERROR') {
    return res.status(500).json({
      success: false,
      message: 'Database access denied. Check credentials.',
    });
  }

  if (err.code === 'ECONNREFUSED') {
    return res.status(500).json({
      success: false,
      message: 'Cannot connect to database. Is MySQL running?',
    });
  }

  return res.status(err.status || 500).json({
    success: false,
    message: err.message || 'Internal server error.',
  });
};

module.exports = { validateScanInput, globalErrorHandler };