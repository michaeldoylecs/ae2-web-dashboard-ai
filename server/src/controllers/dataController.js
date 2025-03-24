const GameData = require('../models/gameData');

exports.storeData = async (req, res) => {
    try {
        const savedData = await GameData.create(req.body);
        res.status(201).json(savedData);
    } catch (error) {
        res.status(400).json({ message: error.message });
    }
};
