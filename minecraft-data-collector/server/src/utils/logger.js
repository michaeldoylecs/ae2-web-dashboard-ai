const winston = require('winston');

const logger = winston.createLogger({
    level: 'info',
    format: winston.format.combine(
        winston.format.timestamp(),
        winston.format.json()
    ),
    transports: [
        new winston.transports.File({ filename: 'server.log' })
    ]
});

// Middleware for request logging
logger.middleware = (req, res, next) => {
    logger.info(`${req.method} ${req.path}`);
    next();
};

module.exports = logger;
