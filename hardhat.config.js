require('dotenv').config();
require("@nomiclabs/hardhat-ethers");
require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan");

const { API_KEY, PRIVATE_KEY, API_KEY_RINK, ETHERSCAN_API_KEY, API_KEY_MAIN, API_KEY_POLY, POLYSCAN_API_KEY} = process.env;
/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: "0.8.6",
  networks: {
    ropsten: {
      url: `https://eth-ropsten.alchemyapi.io/v2/${API_KEY}`,
      accounts: [`0x${PRIVATE_KEY}`]
    },
	rinkeby: {
      url: `https://eth-rinkeby.alchemyapi.io/v2/${API_KEY_RINK}`,
      accounts: [`0x${PRIVATE_KEY}`]
    },
	mainnet: {
	url: `https://eth-mainnet.alchemyapi.io/v2/${API_KEY_MAIN}`, 
    accounts: [`0x${PRIVATE_KEY}`]
	//gasPrice: 0xF2C0BED7757
    },
	polygon: {
	url: `https://polygon-mainnet.g.alchemy.com/v2/${API_KEY_POLY}`, 
    accounts: [`0x${PRIVATE_KEY}`]
	}
  },
  etherscan: {
    apiKey: POLYSCAN_API_KEY
  },
  polyscan: {
	  apiKey: POLYSCAN_API_KEY
  }
};