const main = async () => {
        const gameContractFactory = await hre.ethers.getContractFactory('GameContract');
        const gameContract = await gameContractFactory.deploy(
                ['Viking', 'Archer', 'Mage'],
                [
                        'https://cloudflare-ipfs.com/ipfs/QmRvyM7XTKDWKgUGHZ59qqrzuNF76qbLhSGX34gdoV4o4G',
                        'https://cloudflare-ipfs.com/ipfs/Qmava7Y9FPqeSs1pRTMJuRTHBPzcasDW73t6nm3v686nht',
                        'https://cloudflare-ipfs.com/ipfs/QmVJK7jt2PHF7NSRsdsFR9AzDGJBzu4MVg2Tp4LgcpoqDZ',
                ],
                [200, 500, 175],
                [500, 190, 1000]
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
