// latest deploy 0xab7AE30660B861d7B49B4a5779A530DfDa0EcEE9

const hre = require('hardhat');

const main = async () => {
        const gameContractFactory = await hre.ethers.getContractFactory('GameContract');
        const gameContract = await gameContractFactory.deploy(
                ['Viking', 'Archer', 'Mage'],
                [
                        'https://ipfs.io/ipfs/QmRvyM7XTKDWKgUGHZ59qqrzuNF76qbLhSGX34gdoV4o4G',
                        'https://ipfs.io/ipfs/QmP2g8emxZM6Vuf55iZ3pfEnNbA148kA5u5CyogGZ6W7we',
                        'https://ipfs.io/ipfs/QmVJK7jt2PHF7NSRsdsFR9AzDGJBzu4MVg2Tp4LgcpoqDZ',
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
};

const runMain = async () => {
        try {
                await main();
                process.exit(0);
        } catch (error) {
                console.log(error);
                process.exit(1);
        }
};

runMain();
