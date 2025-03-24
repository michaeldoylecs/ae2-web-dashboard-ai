const mongoose = require('mongoose');

const gameDataSchema = new mongoose.Schema({
    coordinates: {
        x: Number,
        y: Number,
        z: Number
    },
    inventory: [{
        item: String,
        count: Number
    }],
    energy: Number,
    timestamp: {
        type: Date,
        default: Date.now
    }
});

module.exports = mongoose.model('GameData', gameDataSchema);
