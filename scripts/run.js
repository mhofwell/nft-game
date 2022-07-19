const main = async () => {
        const gameContractFactory = await hre.ethers.getContractFactory('GameContract');
        const gameContract = await gameContractFactory.deploy(
                ['Viking', 'Crossbowman', 'Mage'],
                [0, 0, 0],
                [200, 500, 175],
                [500, 190, 1000]
        );
        await gameContract.deployed();
        console.log('Contract deployed to:', gameContract.address);
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
