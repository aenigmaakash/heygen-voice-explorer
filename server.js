const express = require('express');
const axios = require('axios');
const cors = require('cors');
const path = require('path');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.static(path.join(__dirname, 'dist')));

// API key from environment variable
const API_KEY = process.env.VUE_APP_HEYGEN_API_KEY;
if (!API_KEY) {
  console.error('Error: VUE_APP_HEYGEN_API_KEY environment variable is not set');
  process.exit(1);
}

// Proxy route for voices API
app.get('/api/voices', async (req, res) => {
  try {
    const response = await axios.get('https://api.heygen.com/v2/voices', {
      headers: {
        'accept': 'application/json',
        'x-api-key': API_KEY
      }
    });
    
    res.json(response.data);
  } catch (error) {
    console.error('Error fetching voices:', error);
    res.status(error.response?.status || 500).json({
      error: 'Failed to fetch voices from Heygen API',
      details: error.message
    });
  }
});

// Handle SPA routing
app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, 'dist', 'index.html'));
});

// Start server
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
}); 