const VotingContract = artifacts.require("VotingContract");

contract('VotingContract', accounts => {
    it('Admin should create ballot', async () => {
        const votingContractInstance = await VotingContract.deployed();
        await votingContractInstance.createBallot('Ballot Name', {from: accounts[0]});
        //console.log(votingContractInstance);
        //console.log(await votingContractInstance.getAllBallots());
        //console.log(typeof(await votingContractInstance.getAllBallots()));
        const obj = await votingContractInstance.getAllBallots();
        console.log(obj);
        console.log(obj[0]);
        console.log(obj[0].name);


        //const ballotsLength = await votingContractInstance.getAllBallots().length;
        //const ballotName = await votingContractInstance.getBallotById(0).name;

        //assert.equal(ballotsLength, 1, "Ballot length does not equal 1.");
        //assert.equal(ballotName, "Ballot Name", "Ballot name does not equal 'Ballot Name'.");
    });



    /*
  it('should put 10000 MetaCoin in the first account', async () => {
    const metaCoinInstance = await MetaCoin.deployed();
    const balance = await metaCoinInstance.getBalance.call(accounts[0]);

    assert.equal(balance.valueOf(), 10000, "10000 wasn't in the first account");
  });
  it('should call a function that depends on a linked library', async () => {
    const metaCoinInstance = await MetaCoin.deployed();
    const metaCoinBalance = (await metaCoinInstance.getBalance.call(accounts[0])).toNumber();
    const metaCoinEthBalance = (await metaCoinInstance.getBalanceInEth.call(accounts[0])).toNumber();

    assert.equal(metaCoinEthBalance, 2 * metaCoinBalance, 'Library function returned unexpected function, linkage may be broken');
  });
  it('should send coin correctly', async () => {
    const metaCoinInstance = await MetaCoin.deployed();

    // Setup 2 accounts.
    const accountOne = accounts[0];
    const accountTwo = accounts[1];

    // Get initial balances of first and second account.
    const accountOneStartingBalance = (await metaCoinInstance.getBalance.call(accountOne)).toNumber();
    const accountTwoStartingBalance = (await metaCoinInstance.getBalance.call(accountTwo)).toNumber();

    // Make transaction from first account to second.
    const amount = 10;
    await metaCoinInstance.sendCoin(accountTwo, amount, { from: accountOne });

    // Get balances of first and second account after the transactions.
    const accountOneEndingBalance = (await metaCoinInstance.getBalance.call(accountOne)).toNumber();
    const accountTwoEndingBalance = (await metaCoinInstance.getBalance.call(accountTwo)).toNumber();


    assert.equal(accountOneEndingBalance, accountOneStartingBalance - amount, "Amount wasn't correctly taken from the sender");
    assert.equal(accountTwoEndingBalance, accountTwoStartingBalance + amount, "Amount wasn't correctly sent to the receiver");
  });
  */
});
