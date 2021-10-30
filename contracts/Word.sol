//word contract, make blurb up here

pragma solidity 0.8.6;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Word is ERC721Enumerable, ReentrancyGuard, Ownable {
	
	uint32 freeWords;
	uint32 wordsMade;
	
	
	constructor (string memory _name, string memory _symbol) ERC721(_name, _symbol) Ownable()
    {
		wordsMade = 0;
		freeWords = 1;
		_safeMint(_msgSender(), 0);
    }
	
	function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }
	
	//uses the random function, in combination with tokenID and a string, to generate and return a letter
	function getALetter(uint256 tokenId, string memory keyPrefix) internal view returns (uint256) {
        uint256 rand = random(string(abi.encodePacked(keyPrefix, toString(tokenId))));
		return rand;
	}
	
	//pay to mint a word ***INCOMPLETE***
	function buyWord(uint256 tokenId) public payable nonReentrant {
		require(msg.value > 1);
		///deposit(msg.value);
		payable(owner()).transfer(msg.value);

		///owner.transfer(msg.value);
		wordsMade+=1;
		_safeMint(_msgSender(), tokenId);
	}
	
	//mint a word for free, when free is available ***INCOMPLETE***
	//also make it so people that already have a word can't claim free words
	function freeWord(uint256 tokenId) public nonReentrant {
		//require(freeWords > 0);
		//require(balanceOf(msg.sender) == 0);
		wordsMade+=1;
		_safeMint(_msgSender(), tokenId);
	}
	
	//increase number of free word
	function moreFreeWords(uint32 moreWords) public onlyOwner {
		freeWords += moreWords;
	}
	
	
	//generates tokenURI, and the word along with it ***INCOMPLETE***
	//need to fill in the A's with 4 unique random methods.
	function tokenURI(uint256 tokenId) public view override returns (string memory) {
        string[9] memory parts;
        parts[0] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 100 50"><style>.base { fill: white; font-family: serif; font-size: 14px; }</style><rect width="100%" height="100%" fill="black" /><text x="20" y="15" class="base">WORD...?</text>';

        parts[1] = 'A';

        parts[2] = '</text><text x="15" y="40" class="base">';

        parts[3] = 'A';

        parts[4] = '</text><text x="35" y="40" class="base">';

        parts[5] = 'A';

        parts[6] = '</text><text x="55" y="40" class="base">';

        parts[7] = 'A';

        parts[8] = '</text><text x="75" y="40" class="base">';


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