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

    struct BigBoss {
        string name;
        string imageURI;
        uint256 hp;
        uint256 maxHp;
        uint256 attackDamage;
    }

    BigBoss public bigBoss;

    // A mapping from an address => the NFTs _tokenId. Gives me an easy way to store
    // the owner of the NFT and reference it later.

    mapping(address => uint256) public nftHolders;

    event CharacterNFTMinted(
        address sender,
        uint256 tokenId,
        uint256 characterIndex
    );
    event AttackComplete(
        address sender,
        uint256 newBossHp,
        uint256 newPlayerHp
    );

    constructor(
        string[] memory characterNames,
        string[] memory characterImageURIs,
        uint256[] memory characterHp,
        uint256[] memory characterAttackDmg,
        string memory bossName,
        string memory bossImageURI,
        uint256 bossHp,
        uint256 bossAttackDamage
    ) ERC721("Legends", "LGND") {
        // initialize the boss. Save it to our global "BigBoss" state variable.

        bigBoss = BigBoss({
            name: bossName,
            imageURI: bossImageURI,
            hp: bossHp,
            maxHp: bossHp,
            attackDamage: bossAttackDamage
        });

        console.log(
            "Done initializing boss %s with %s HP, image at %s",
            bigBoss.name,
            bigBoss.hp,
            bigBoss.imageURI
        );

        // initialize the character attributes for each character.

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

    function attackBoss() public {
        uint256 tokenIdOfPlayer = nftHolders[msg.sender];
        Attributes storage player = nftHolderAttributes[tokenIdOfPlayer];
        console.log(
            "\nPlayer with character %s is about to attack. Has %s HP and %s AD",
            player.name,
            player.hp,
            player.attackDamage
        );
        console.log(
            "%s has %s HP an %s AD",
            bigBoss.name,
            bigBoss.hp,
            bigBoss.attackDamage
        );

        require(player.hp > 0, "Player has no HP Left!.");

        require(bigBoss.hp > 0, "Boss is dead! Hurray!");

        // Allow player to attack boss

        if (bigBoss.hp < player.attackDamage) {
            bigBoss.hp = 0;
        } else {
            bigBoss.hp = bigBoss.hp - player.attackDamage;
        }

        // Allow boss to attack player

        if (player.hp < bigBoss.attackDamage) {
            player.hp = 0;
        } else {
            player.hp = player.hp - bigBoss.attackDamage;
        }

        console.log(
            "Player damaged the %s! %s HP remaining",
            bigBoss.name,
            bigBoss.hp
        );
        console.log(
            "%s attacked you! You have %s HP left.",
            bigBoss.name,
            player.hp
        );

        // emit event

        emit AttackComplete(msg.sender, bigBoss.hp, player.hp);
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

        // emit event

        emit CharacterNFTMinted(msg.sender, newNFTId, _characterIndex);
    }

    function returnUsersNFT() public view returns (Attributes memory) {
        uint256 tokenId = nftHolders[msg.sender];

        if (tokenId > 0) {
            Attributes storage playerCharacter = nftHolderAttributes[tokenId];
            return playerCharacter;
        } else {
            console.log("You have not yet minted a character!");
            Attributes memory emptyStruct;
            return emptyStruct;
        }
    }

    function getAllCharacters() public view returns (Attributes[] memory) {
        return startingCharacters;
    }

    function getBoss() public view returns (BigBoss memory) {
        return bigBoss;
    }
}
