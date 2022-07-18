require("@nomicfoundation/hardhat-toolbox");
require("@nomiclabs/hardhat-etherscan");

require('dotenv').config();


const etherScanAPI = process.env.ETHER_SCAN;
/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.9",
   etherscan: {
    apiKey: "etherScanAPI"
  }
};
