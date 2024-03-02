const express = require('express');
const router = express.Router();

// Example endpoint for fetching the current block number
router.get('/blockNumber', async (req, res) => {
    try {
        const blockNumber = await web3.eth.getBlockNumber();
        res.json({ blockNumber });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Failed to fetch block number' });
    }
});

// Additional endpoints for interacting with smart contracts

module.exports = router;
