const main = async () => {
        const gameContractFactory = await hre.ethers.getContractFactory('GameContract');
        const gameContract = await gameContractFactory.deploy(
                ['Viking', 'Archer', 'Mage'],
                [
                        'ipfs://QmRvyM7XTKDWKgUGHZ59qqrzuNF76qbLhSGX34gdoV4o4G',
                        'ipfs://QmP2g8emxZM6Vuf55iZ3pfEnNbA148kA5u5CyogGZ6W7we',
                        'ipfs://QmVJK7jt2PHF7NSRsdsFR9AzDGJBzu4MVg2Tp4LgcpoqDZ',
                ],
                [200, 500, 175],
                [500, 190, 1000],
                'Evil Warlock',
                'https://cloudflare-ipfs.com/ipfs/QmYztjGhCPsMWQkeaJqcJB9SYxnp8MviUptd3uTEkDSEEG',
                10000,
                50
        );
        await gameContract.deployed();
        console.log('Contract deployed to:', gameContract.address);

        let txn;
        // we only have 3 characters
        // an NFT w/ the character at index 2 of our array

        txn = await gameContract.mintGameNFT(2);
        await txn.wait();

        // Get the value of the NFT's URI
        const returnedTokenURI = await gameContract.tokenURI(1);
        console.log('Token URI', returnedTokenURI);

        txn = await gameContract.attackBoss();
        await txn.wait;

        txn = await gameContract.attackBoss();
        await txn.wait;
};

const runMain = async () => {
        try {
                await main();
                process.exit(0);
        } catch (e) {
                console.log(e);
                process.exit(1);
        }
};

runMain();
