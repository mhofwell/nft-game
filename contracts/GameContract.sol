// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.1;

// NFT contract to inherit from
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

// Helper functions from OpenZeppelin

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

// CONSOLE log for solidity
import "hardhat/console.sol";

// Helper we wrote to encode in Base64
import "./libraries/Base64.sol";

// Contract inherits from ERC721

contract GameContract is ERC721 {
    struct Attributes {
        uint256 index;
        string name;
        string imageURI;
        uint256 hp;
        uint256 maxHp;
        uint256 attackDamage;
    }

    // The tokenId is the NFT's unique identifier, it the collection # of the NFT

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // array to help us hold the default data for our characters.
    Attributes[] startingCharacters;

    // we create a mapping from the NFTs _tokenId => that NFTs attributes.
    mapping(uint256 => Attributes) public nftHolderAttributes;

    // A mapping from an address => the NFTs _tokenId. Gives me an easy way to store
    // the owner of the NFT and reference it later.

    mapping(address => uint256) public nftHolders;

    constructor(
        string[] memory characterNames,
        string[] memory characterImageURIs,
        uint256[] memory characterHp,
        uint256[] memory characterAttackDmg
    ) ERC721("Legends", "LGND") {
        for (uint256 i = 0; i < characterNames.length; i += 1) {
            startingCharacters.push(
                Attributes({
                    index: i,
                    name: characterNames[i],
                    imageURI: characterImageURIs[i],
                    hp: characterHp[i],
                    maxHp: characterHp[i],
                    attackDamage: characterAttackDmg[i]
                })
            );

            Attributes memory c = startingCharacters[i];

            // Hardhat's use of console.log() allows up to 4 parameters in any order of following types: uint, string, bool, address
            console.log(
                "Done initializing %s with %s damage and %s HP",
                c.name,
                c.attackDamage,
                c.hp
            );
        }

        // I increment _tokenIds here so that my first NFT has an ID of 1.
        // More on this in the lesson!
        _tokenIds.increment();
    }

    // Users would be able to hit this function and get their NFT based on the
    // characterId they send in!

    function tokenURI(uint256 _tokenId)
        public
        view
        override
        returns (string memory)
    {
        Attributes memory charAttributes = nftHolderAttributes[_tokenId];

        string memory strHp = Strings.toString(charAttributes.hp);
        string memory strMaxHp = Strings.toString(charAttributes.maxHp);
        string memory strAttackDamage = Strings.toString(
            charAttributes.attackDamage
        );

        string memory json = Base64.encode(
            abi.encodePacked(
                '{"name": "',
                charAttributes.name,
                " -- NFT #: ",
                Strings.toString(_tokenId),
                '", "description": "HERO NFT from the Legends Collection", "image": "',
                charAttributes.imageURI,
                '", "attributes": [ { "trait_type": "HP", "value": ',
                strHp,
                ', "max_value":',
                strMaxHp,
                '}, { "trait_type": "Attack Damage", "value": ',
                strAttackDamage,
                "} ]}"
            )
        );

        string memory nftMetaData = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        return nftMetaData;
    }

    function mintGameNFT(uint256 _characterIndex) external {
        // get current tokenId (starts at 1 since we incremented in the constructor)
        uint256 newNFTId = _tokenIds.current();

        // the magical function! assigns the tokenId to the caller's wallet address

        _safeMint(msg.sender, newNFTId);

        // we map the tokenId => their character attributes.
        nftHolderAttributes[newNFTId] = Attributes({
            index: _characterIndex,
            name: startingCharacters[_characterIndex].name,
            imageURI: startingCharacters[_characterIndex].imageURI,
            hp: startingCharacters[_characterIndex].hp,
            maxHp: startingCharacters[_characterIndex].maxHp,
            attackDamage: startingCharacters[_characterIndex].attackDamage
        });

        console.log(
            "Minted %s Class Legends NFT, Mint Number %s",
            startingCharacters[_characterIndex].name,
            newNFTId
        );

        // Keep an easy way to see who owns what NFT;
        nftHolders[msg.sender] = newNFTId;

        // Increment the _tokenId for the next person who uses it.
        _tokenIds.increment();
    }
}
