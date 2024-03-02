document.addEventListener('DOMContentLoaded', function () {
    const connectButton = document.getElementById('connectButton');
    const statusDiv = document.getElementById('status');
    const walletAddressDiv = document.getElementById('walletAddress');

    connectButton.addEventListener('click', async () => {
        if (window.ethereum) {
            try {
                await window.ethereum.request({ method: 'eth_requestAccounts' });
                const accounts = await window.ethereum.request({ method: 'eth_accounts' });
                if (accounts.length > 0) {
                    statusDiv.textContent = "Wallet connected.";
                    walletAddressDiv.textContent = `Wallet Address: ${accounts[0]}`;
                } else {
                    statusDiv.textContent = "Please connect to MetaMask.";
                }
            } catch (error) {
                statusDiv.textContent = `Error: ${error.message}`;
            }
        } else {
            statusDiv.textContent = "MetaMask is not installed.";
        }
    });
});
