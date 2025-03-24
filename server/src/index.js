const express = require('express');
const config = require('../config/default');
const logger = require('./utils/logger');

const app = express();

// Middleware
app.use(express.json());
app.use(logger.middleware);

// Routes
app.use('/api', require('./routes/api'));

app.listen(config.port, () => {
    console.log(`Server running on port ${config.port}`);
});
