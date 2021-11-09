//word contract, make blurb up here

pragma solidity 0.8.6;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Word is ERC721Enumerable, ReentrancyGuard, Ownable {
	
	uint32 freeWords;
	uint32 wordsMade;
	
	//***INCOMPLETE*** need to set freeWords to..... well more then 1 initially
	constructor (string memory _name, string memory _symbol) ERC721(_name, _symbol) Ownable()
    {
		wordsMade = 1;
		freeWords = 1;
		_safeMint(_msgSender(), 0);
    }
	
	function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }
	
	function letterOne(uint256 tokenId) public view returns (string memory) {
		require(tokenId < wordsMade, "Word not made yet.");
		return getALetter(tokenId, "ONE");
	}
	
	function letterTwo(uint256 tokenId) public view returns (string memory) {
		require(tokenId < wordsMade, "Word not made yet.");
		return getALetter(tokenId, "TWO");
	}
	
	function letterThree(uint256 tokenId) public view returns (string memory) {
		require(tokenId < wordsMade, "Word not made yet.");
		return getALetter(tokenId, "THREE");
	}
	
	function letterFour(uint256 tokenId) public view returns (string memory) {
		require(tokenId < wordsMade, "Word not made yet.");
		return getALetter(tokenId, "FOUR");
	}
	
	function freeWordsLeft() public view returns (uint32) {
		return freeWords;
	}
	
	function wordsCreated() public view onlyOwner returns(uint32) {
		return wordsMade;
	}
	
	//uses the random function, in combination with tokenID and a string, to generate and return a letter
	//***INCOMPLETE*** only returns A, need to actually make the function
	function getALetter(uint256 tokenId, string memory keyPrefix) internal view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked(keyPrefix, toString(tokenId))));
		return "A";
	}
	
	//pay to mint a word ***INCOMPLETE***
	function buyWord() public payable nonReentrant {
		require(msg.value > 1);
		payable(owner()).transfer(msg.value);
		wordsMade++;
		_safeMint(_msgSender(), wordsMade-1);
	}
	
	//mint a word for free, when free is available ***INCOMPLETE***
	//also make it so people that already have a word can't claim free words
	function freeWord() public nonReentrant {
		require(balanceOf(msg.sender) == 0, "Already own a word.");
		require(freeWords > 0, "No more free words.");
		wordsMade++;
		freeWords--;
		_safeMint(_msgSender(), wordsMade-1);
	}
	
	//increase number of free word
	function moreFreeWords(uint32 moreWords) public onlyOwner {
		freeWords += moreWords;
	}
	
	
	//generates tokenURI, and the word along with it ***INCOMPLETE***
	//need to fill in the A's with 4 unique random methods.
	
	function tokenURI(uint256 tokenId) public view override returns (string memory) {
        string[9] memory parts;
        parts[0] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 100 50"><style>.base { fill: white; font-family: serif; font-size: 14px; }</style><rect width="100%" height="100%" fill="black" /><text x="20" y="15" class="base">WORD...?</text><text x="15" y="40" class="base">';

        parts[1] = letterOne(tokenId);

        parts[2] = '</text><text x="35" y="40" class="base">';

        parts[3] = letterTwo(tokenId);

        parts[4] = '</text><text x="55" y="40" class="base">';

        parts[5] = letterThree(tokenId);

        parts[6] = '</text><text x="75" y="40" class="base">';

        parts[7] = letterFour(tokenId);

        parts[8] = '</text></svg>';


        string memory output = string(abi.encodePacked(parts[0], parts[1], parts[2], parts[3], parts[4], parts[5], parts[6], parts[7], parts[8]));
        

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "Word...? ',
                        toString(tokenId),
                        '", "description": "this is a word maybe", "image": "data:image/svg+xml;base64,',
                        Base64.encode(bytes(output)),
                        '"}'
                    )
                )
            )
        );
        output = string(abi.encodePacked("data:application/json;base64,", json));

        return output;
    }
	
		//MIT license
	function toString(uint256 value) internal pure returns (string memory) {
       
        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }
	
	
}


library Base64 {
    bytes internal constant TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

    /// @notice Encodes some bytes to the base64 representation
    function encode(bytes memory data) internal pure returns (string memory) {
        uint256 len = data.length;
        if (len == 0) return "";

        // multiply by 4/3 rounded up
        uint256 encodedLen = 4 * ((len + 2) / 3);

        // Add some extra buffer at the end
        bytes memory result = new bytes(encodedLen + 32);

        bytes memory table = TABLE;

        assembly {
            let tablePtr := add(table, 1)
            let resultPtr := add(result, 32)

            for {
                let i := 0
            } lt(i, len) {

            } {
                i := add(i, 3)
                let input := and(mload(add(data, i)), 0xffffff)

                let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
                out := shl(8, out)
                out := add(out, and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF))
                out := shl(8, out)
                out := add(out, and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF))
                out := shl(8, out)
                out := add(out, and(mload(add(tablePtr, and(input, 0x3F))), 0xFF))
                out := shl(224, out)

                mstore(resultPtr, out)

                resultPtr := add(resultPtr, 4)
            }

            switch mod(len, 3)
            case 1 {
                mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
            }
            case 2 {
                mstore(sub(resultPtr, 1), shl(248, 0x3d))
            }

            mstore(result, encodedLen)
        }

        return string(result);
    }
}