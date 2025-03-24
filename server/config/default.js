module.exports = {
    port: process.env.PORT || 3000,
    mongo_uri: process.env.MONGO_URI || 'mongodb://localhost:27017/minecraft-data',
    api_key: process.env.API_KEY || 'your-secret-key'
};
