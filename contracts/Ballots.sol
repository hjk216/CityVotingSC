// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "./VotingContract.sol";

contract Ballots {
	struct Candidate {
		uint id;
		string name;
		uint votes;
	}

	struct Election {
		uint id;
		string name;
		uint currentCandidateId;
		Candidate[] candidates;
	}

	struct Issue {
		uint id;
		string name;
		uint forVotes;
		uint againstVotes;
	}

	struct Ballot {
		uint id;
		string name;
		uint status;
		uint currentElectionId;
		uint currentIssueId;
		Election[] elections;
		Issue[] issues;
	}

	/// @notice State of ballot variables for Ballot.status
	uint CLOSED = 0;
	uint OPEN = 1;
	uint COMPLETE = 2;

    /// @notice Current Ballot ID
	uint currentBallotId;
    
    /// @notice List of ballots
	Ballot[] ballotsList;

	/// @notice Owner of contract
    VotingContract owner;

    constructor() {
        owner = VotingContract(msg.sender);
    }

	error NotOwner(string message);
	error BallotNotClosed(string message);

    modifier onlyOwner() {
		if (msg.sender != address(owner)) {
			revert NotOwner("Only Owner May Call Function");
		}
		_;
	}

	modifier ballotClosed() {
		if (ballotsList.length == 0 || ballotsList[currentBallotId].status != 0) {
			revert BallotNotClosed("Ballot Must Be Closed");
		}
		_;
	}



	// ==============================================================

	// Functions ====================================================

	// ==============================================================



	// Info Functions ===============================================
	
	// Get current ballot status
	function getCurrentBallotStatus() public view onlyOwner returns (uint) {
		require(ballotsList.length > 0);
		return ballotsList[currentBallotId].status;
	}

	// Get current ballot info
	function getCurrentBallot() external view onlyOwner returns (Ballot memory) {
		require (ballotsList.length > 0, "No Ballot Has Been Created");
		return ballotsList[currentBallotId];
	} 

	// List all ballot ids and names
	function getAllBallots() external view onlyOwner returns (Ballot[] memory) {
		return ballotsList;
	}

	// Get ballot info by id
	function getBallotById(uint _id) external view onlyOwner returns (Ballot memory) {
		require (_id >= 0 && _id < ballotsList.length);
		return ballotsList[_id];
	} 

	// ==============================================================



	// Admin Ballot Functions =======================================

	// Create ballot
	function createBallot(string memory _name) external onlyOwner {
		require(ballotsList.length == 0 || ballotsList[currentBallotId].status == COMPLETE);
		if(ballotsList.length != 0) { currentBallotId++; }
		ballotsList.push();
		Ballot storage newBallot = ballotsList[ballotsList.length - 1];

		newBallot.id = currentBallotId;
		newBallot.name = _name;
		newBallot.status = CLOSED;
		newBallot.currentElectionId = 0;
		newBallot.currentIssueId = 0;
	}

	// Delete ballot
	function deleteBallot() external onlyOwner ballotClosed {
		ballotsList.pop();
		currentBallotId--;
	}

	// Open ballot, close ballot
	function openCloseBallot() external onlyOwner {
		if(ballotsList[currentBallotId].status == CLOSED) {
			ballotsList[currentBallotId].status = OPEN;
		} else {
			ballotsList[currentBallotId].status = COMPLETE;
		}
	}

	// ==============================================================



	// Admin Election Functions =====================================

	// Add election
	function addElections(string[][] memory elections) external onlyOwner ballotClosed {
		for (uint i = 0; i < elections.length; i++) {
			if (ballotsList[currentBallotId].elections.length != 0) { ballotsList[currentBallotId].currentElectionId++; }
			ballotsList[currentBallotId].elections.push();
			Election storage newElection = ballotsList[currentBallotId].elections[ballotsList[currentBallotId].elections.length - 1];
			
			newElection.id = ballotsList[currentBallotId].currentElectionId;
			newElection.name = elections[i][0];
			newElection.currentCandidateId = 0;

			for (uint c = 1; c < elections[i].length; c++) {
				if (newElection.candidates.length != 0) { newElection.currentCandidateId++; }
				newElection.candidates.push();
				Candidate storage newCandidate = newElection.candidates[c - 1];
				newCandidate.name = elections[i][c];
			}
		}
	}

	// ==============================================================



	// Admin Issue Functions ========================================

	// Add issues
	function addIssues(string[] memory issues) external onlyOwner ballotClosed {
		for (uint i = 0; i < issues.length; i++) {
			if (ballotsList[currentBallotId].issues.length != 0) { ballotsList[currentBallotId].currentIssueId++; }
			ballotsList[currentBallotId].issues.push();
			Issue storage newIssue = ballotsList[currentBallotId].issues[ballotsList[currentBallotId].issues.length - 1];

			newIssue.id = ballotsList[currentBallotId].currentIssueId;
			newIssue.name = issues[i];
			newIssue.forVotes = 0;
			newIssue.againstVotes = 0;
		}
	}

	// ==============================================================



	// Voter Functions ==============================================

	// Vote for all
	// [ [ TYPE , ID , VOTE ]   ]
	// [ [ ELECTION , 0 , VOTE ] ]
	// Election = 0, Issue = 1
	// uint AGAINST = 0;
	// uint FOR = 1;
	function vote(uint[][] memory votes) external onlyOwner {
		require(getCurrentBallotStatus() == 1);

		for (uint i = 0; i < votes.length; i++) {
			// Vote for election or issue
			if (votes[i][0] == 0) {
				ballotsList[currentBallotId].elections[votes[i][1]].candidates[votes[i][2]].votes++;
			} else {
				// Vote for or against issue
				if (votes[i][2] == 1) {
					ballotsList[currentBallotId].issues[votes[i][1]].forVotes++;
				} else {
					ballotsList[currentBallotId].issues[votes[i][1]].againstVotes++;
				}
			}
		}


	}

	// ==============================================================



	// Other Functions ==============================================

	// ==============================================================



}
