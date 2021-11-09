const { expect } = require("chai");

describe("Word contract", function () {
	this.timeout(500000);
	
	let Word;
	let hardhatWord;
	let owner;
	let addr1;
	let addr2;
	let addrs;
	
	beforeEach(async function () {
    // Get the ContractFactory and Signers here.
    Word = await ethers.getContractFactory("Word");
    [owner, addr1, addr2, ...addrs] = await ethers.getSigners();

    // deploy contract
    hardhatWord = await Word.deploy("Word", "WORD");
  });
  
  it("User should be able to claim one and only one free word.", async function () {
    
    await hardhatWord.connect(owner).freeWord();//owner requests free word, and receives one
   
    expect(await hardhatWord.ownerOf(0)).to.equal(owner.address);//confirming it
	
	await expect(hardhatWord.connect(owner).freeWord()).to.be.revertedWith("Already own a word.");//owner requesting a free word while they already own a word, rejected
  });
  
  it("User may not receive a free word when the number of free words available is zero.", async function () {
	await hardhatWord.connect(owner).freeWord();//owner requests free word, and receives one, decreasing freeword could to 0
	
	await expect(hardhatWord.connect(addr1).freeWord()).to.be.revertedWith("No more free words.");//other address requests free word, but none are available, revert
  });
  
  it("Only the owner may add more free words.", async function () {
	await hardhatWord.connect(owner).freeWord();//owner requests free word, and receives one, decreasing freeword could to 0
	
	await expect(hardhatWord.connect(addr1).freeWord()).to.be.reverted;//other address requests free word, but none are available, revert
	
	await expect(hardhatWord.connect(addr1).moreFreeWords(1)).to.be.revertedWith('caller is not the owner');//addr1 tries to add a new word, fails
	
	await expect(hardhatWord.connect(addr1).freeWord()).to.be.reverted;//other address requests free word, but none are available, revert

	await hardhatWord.connect(owner).moreFreeWords(1);//owner adds a new word
	
	await expect(hardhatWord.connect(owner).freeWord()).to.be.revertedWith("Already own a word.");//owner requesting a free word while they already own a word, rejected
  
	await hardhatWord.connect(addr1).freeWord();//addr1 requests and receives free word
	
	expect(await hardhatWord.ownerOf(1)).to.equal(addr1.address);//confirming it
  });
  
  it("Check that getting a letter works.", async function () {
	await expect(hardhatWord.connect(addr1).letterOne(0)).to.be.revertedWith("Word not made yet.");
	
	await hardhatWord.connect(owner).freeWord();
	
	const letter = await hardhatWord.connect(addr1).letterOne(0);
	
	expect(letter).to.equal("A");//other address requests free word, but none are available, revert
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