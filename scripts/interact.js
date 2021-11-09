// interact.js

const API_KEY = process.env.API_KEY_RINK;
const PRIVATE_KEY = process.env.PRIVATE_KEY;
const CONTRACT_ADDRESS = process.env.CONTRACT_ADDRESS_RINK;

const contract = require("../artifacts/contracts/Word.sol/Word.json");
//console.log(JSON.stringify(contract.abi));



// Provider
const alchemyProvider = new ethers.providers.AlchemyProvider(network="rinkeby", API_KEY);

// Signer
const signer = new ethers.Wallet(PRIVATE_KEY, alchemyProvider);

// Contract
const WordContract = new ethers.Contract(CONTRACT_ADDRESS, contract.abi, signer);

async function main() {
 const getWord = await WordContract.freeWord();//owner requests free word, and receives one
  await getWord.wait();
    
	//const addd = WordContract.ownerOf(0);
	console.log("The owner of 0 is: " + WordContract.ownerOf(0));
}
main();