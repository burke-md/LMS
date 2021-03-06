require("@nomicfoundation/hardhat-toolbox");
require("@nomiclabs/hardhat-etherscan");
require('@nomiclabs/hardhat-ethers');

require('dotenv').config();


const etherScanAPI = process.env.ETHER_SCAN;
const alchemyApiKey = process.env.ALCHEMY_API;
const mnemonic = process.env.MNEMONIC;

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: {
      version: "0.8.15",
      settings: {
        optimizer: {
          enabled: true,
          runs: 10000,
        },
      },
    },
  networks: {
     rinkeby: {
       url: `https://eth-rinkeby.alchemyapi.io/v2/${alchemyApiKey}`,
       accounts: { mnemonic: mnemonic },
     },
  },
  etherscan: {
    apiKey: etherScanAPI
  }
};
