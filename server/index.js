const express = require('express');
const app = express();
const port = process.env.PORT || 3000;

// Middleware
app.use(express.json());

// Blockchain API routes
app.use('/api', require('./api/blockchainApi'));

app.listen(port, () => {
    console.log(`Server listening at http://localhost:${port}`);
});
