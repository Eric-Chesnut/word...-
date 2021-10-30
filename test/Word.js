const { expect } = require("chai");

describe("Word contract", function () {
	this.timeout(500000);
  it("Deployment should assign the total supply of tokens to the owner", async function () {
    const [owner] = await ethers.getSigners();
	
	//import BasicWord from "build/Word.json";
	
	//const hardhatWord = deployContract("Word..?", "WORD");
	
    Word = await ethers.getContractFactory("Word");

    const hardhatWord = await Word.deploy("Word", "WORD");

    //await hardhatWord.freeWord(0);
   
	//expect(
    expect(await hardhatWord.ownerOf(0)).to.equal(owner.address);
	
  });
});




/*
const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Word contract", function () {
	before(async function () {
    this.Word = await ethers.getContractFactory('Word');
  });

  beforeEach(async function () {
    this.hardhatWord = await this.Word.deploy("Word..?", "WORD");
    await this.hardhatWord.deployed();
  });
  it("Deployment should assign the total supply of tokens to the owner", async function () {
    //const [owner] = await ethers.getSigners();

    

    //const getWord = await hardhatWord.freeWord(0);
	//await getWord.wait();
	//owner.address
	expect(1).to.equal(1);
	//expect(this.hardhatWord.deployed()).to.equal(true);
	//expect(await hardhatWord.ownerOf(0)).to.equal(owner.address)
    //expect(await hardhatWord.totalSupply()).to.equal(ownerBalance);
  });
});


/*
const { ethers } = require("hardhat"); // Import the Ethers library
const { expect } = require("chai"); // Import the "expect" function from the Chai assertion library, we'll use this in our test

// "describe" is used to group tests & enhance readability
describe("Word", () => {
  // "it" is a single test case - give it a descriptive name
  it("Should initialize Word contract", async () => {
    // We can refer to the contract by the contract name in 
    // `artifacts/contracts/bored-ape.sol/BoredApeYachtClub.json`
    // initialize the contract factory: https://docs.ethers.io/v5/api/contract/contract-factory/
    const WordFactory = await ethers.getContractFactory("Word");
    // create an instance of the contract, giving us access to all
    // functions & variables
    const wordContract = await WordFactory.deploy(
      "Word....?",
      "WORD",
    );
    // use the "expect" assertion, and read the MAX_APES variable
    expect(await boredApeContract.MAX_APES()).to.equal(5000);
  });
});*/