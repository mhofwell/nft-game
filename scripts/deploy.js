// latest deploy 0x9C696c99Ccd0Cb55e164eCDF344cCF9fa35FeB60

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
                [500, 190, 1000]
        );
        await gameContract.deployed();
        console.log('Contract deployed to Rinkeby at:', gameContract.address);

        let txn;
        txn = await gameContract.mintGameNFT(0);
        await txn.wait();
        console.log('Minted NFT #1');

        txn = await gameContract.mintGameNFT(1);
        await txn.wait();
        console.log('Minted NFT #2');

        txn = await gameContract.mintGameNFT(2);
        await txn.wait();
        console.log('Minted NFT #3');

        txn = await gameContract.mintGameNFT(1);
        await txn.wait();
        console.log('Minted NFT #4');

        console.log('Done deploying and minting!');
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
