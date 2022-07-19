// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract GameContract {
    struct Attributes {
        uint256 index;
        string name;
        string imageURI;
        uint256 hp;
        uint256 maxHp;
        uint256 attackDamage;
    }

    // array to help us hold the default data for our characters.
    Attributes[] startingCharacters;

    constructor(
        string[] memory characterNames,
        string[] memory characterImageURIs,
        uint256[] memory characterHp,
        uint256[] memory characterAttackDmg
    ) {
        // Loop through all the characters and save their values in our contract
        // to use later on.

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
            console.log(
                "Done initializing %s with %s damage and %s HP",
                c.name,
                c.attackDamage,
                c.hp
            );
        }
        console.log("Ready Player One...");
    }
}
