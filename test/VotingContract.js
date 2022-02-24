const VotingContract = artifacts.require("VotingContract");

contract('VotingContract', accounts => {
    it('Admin adds voters, gets voter count, confirms voters', async () => {
        const instance = await VotingContract.deployed();
        await instance.addVoter(accounts[1]);
        await instance.addMultipleVoters([accounts[2], accounts[3]]);
        
        const voterCount = await instance.getVoterCount();
        const isAccountOneVoter = await instance.isVoter(accounts[1]);
        const isAccountThreeVoter = await instance.isVoter(accounts[3]);
        const isNotVoter = await instance.isVoter(accounts[4]);

        assert.equal(voterCount, 3, "Voter count does not equal 3");
        assert.equal(isAccountOneVoter, true, "Account one is not voter");
        assert.equal(isAccountThreeVoter, true, "Account three is not voter");
        assert.equal(isNotVoter, false, "isVoter does not return false for non-voter");
    });

    it('Admin removes voter, gets updated count', async () => {
        const instance = await VotingContract.deployed();
        await instance.removeVoter(accounts[2]);

        const voterCount = await instance.getVoterCount();
        const isVoter = await instance.isVoter(accounts[2]);

        assert.equal(voterCount, 2, "Voter count does not equal 2");
        assert.equal(isVoter, false, "isVoter does not equal false");
    });

    it('Admin creates ballot', async () => {
        const instance = await VotingContract.deployed();
        await instance.createBallot('New Ballot Name');

        const ballotsAll = await instance.getAllBallots();
        const ballot = await instance.getBallotById(0);

        assert.equal(ballotsAll.length, 1, "Ballot length does not equal 1");
        assert.equal(ballot.name, "New Ballot Name", "Ballot name does not equal 'New Ballot Name'");
    });

    it('Admin deletes ballot', async () => {
        const instance = await VotingContract.deployed();
        await instance.deleteBallot();

        const ballotsAll = await instance.getAllBallots();
        
        assert.equal(ballotsAll.length, 0, "Ballots array not empty, does not equal 0");
    });

    it('Admin creates ballot, adds elections and issues to it', async () => { 
        const instance = await VotingContract.deployed();
        await instance.createBallot('New Ballot Name');
        await instance.addElections([['President','Alice','Bob'], ['Vice President', 'Michael', 'Sarah']]);
        await instance.addIssues(['Raise Taxes', 'Preserve Building', 'Green Initiative']);

        const ballot = await instance.getCurrentBallot();
        
        assert.equal(ballot.elections.length, 2, "There are not two elections");
        assert.equal(ballot.elections[0].candidates[0].name, "Alice", "First candidate of first election does not equal 'Alice'");
        assert.equal(ballot.elections[1].candidates[1].name, "Sarah", "Second candidate of second election does not equal 'Sarah'");
        assert.equal(ballot.issues[0].name, "Raise Taxes", "First issue name does not equal 'Raise Taxes'");
        assert.equal(ballot.issues[1].name, "Preserve Building", "Second issue name does not equal 'Preserve Building'");
        assert.equal(ballot.issues[2].name, "Green Initiative", "Third issue name does not equal 'Green Initiative");
    });

    it('Admin opens ballot to voting', async () => {
        const instance = await VotingContract.deployed();

        const beforeStatus = await instance.getCurrentBallotStatus();
        await instance.openCloseBallot();
        const afterStatus = await instance.getCurrentBallotStatus();

        assert.equal(beforeStatus, 0, "Ballot is not closed");
        assert.equal(afterStatus, 1, "Ballot is not open");
    });

    it('Voter votes, and confirms that they have voted', async () => {
        const instance = await VotingContract.deployed();
    
        await instance.vote([[0, 0, 0], [0, 1, 1], [1, 0, 0], [1, 1, 1], [1, 2, 1]], {from: accounts[1]});
        await instance.vote([[0, 0, 0], [0, 1, 0], [1, 0, 1], [1, 1, 1], [1, 2, 1]], {from: accounts[3]});
        
        const ballot = await instance.getCurrentBallot();
        
        const hasVoterOneVoted = await instance.hasVoted(accounts[1], 0);
        const hasVoterThreeVoted = await instance.hasVoted(accounts[3], 0);

        assert.equal(hasVoterOneVoted, true, "User one has not voted");
        assert.equal(hasVoterThreeVoted, true, "User three has not voted");
        assert.equal(
            ballot.elections[0].candidates[0].votes, 2, 
            "Election zero, candidate zero, does not have two votes"
            );
        assert.equal(
            ballot.elections[1].candidates[1].votes, 1, 
            "Election one, candidate one, does not have one vote"
        );
        assert.equal(ballot.issues[0].againstVotes, 1, "Issue zero does not have one againstVote");
        assert.equal(ballot.issues[1].forVotes, 2, "Issue one does not have two forVotes");
        assert.equal(ballot.issues[2].forVotes, 2, "Issue three does not have two forVotes");
    });

    it('Admin closes ballot', async () => {
        const instance = await VotingContract.deployed();
        await instance.openCloseBallot();
        const ballotStatus = await instance.getCurrentBallotStatus();

        assert.equal(ballotStatus, 2, "Ballot status is not complete");
    });

});
