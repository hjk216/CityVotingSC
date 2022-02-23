// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;
//pragma experimental ABIEncoderV2;

import "./Voters.sol";
import "./BallotStorage.sol";

contract VotingContract is BallotStorage {
	
	struct Administrator {
		/// @notice Address for the administrator
		address adminAddress;
	}

	/// @notice Owner of voting contract
    Administrator administrator;

	/// @notice Voter storage and functions
	Voters voters;

	constructor() {
		/// @notice On creation set administrator to creator address
		administrator.adminAddress = msg.sender;

		voters = new Voters();
	}
	


	// Error Messages
	error NotAdmin(string message);
	error BallotNotClosed(string message);

	
	// Modifiers
	modifier onlyOwner() {
		if (msg.sender != administrator.adminAddress) {
			revert NotAdmin("Only Administrator May Call Function");
		}
		_;
	}

	modifier ballotClosed() {
		if (ballotsList.length == 0 || ballotsList[currentBallotId].status != 0) {
			revert BallotNotClosed("Ballot Must Be Closed");
		}
		_;
	}


	
	// Events
	event TestEvent(
		string message
	);



	// Get Information Functions ====================================

	// Get current ballot status
	function getCurrentBallotStatus() public view returns (uint) {
		require(ballotsList.length > 0, "No Ballot Has Been Created");
		return ballotsList[currentBallotId].status;
	}

	// Get current ballot info
	function getCurrentBallot() public view returns (Ballot memory) {
		require (ballotsList.length > 0, "No Ballot Has Been Created");
		return ballotsList[currentBallotId];
	} 

	// List all ballot ids and names
	function getAllBallots() public view returns (Ballot[] memory) {
		return ballotsList;
	}

	// Get ballot info by id
	function getBallotById(uint _id) public view returns (Ballot memory) {
		require (_id < ballotsList.length);
		return (ballotsList[_id]);
	} 

	/// @notice Gets the total voter count in voter roll
	/// @return Total voter count
	function getVoterCount() public view returns (uint) {
		return voters.getVoterCount();
	}

	/// @notice Returns a boolean for whether or not given address is in voter roll
	/// @return True or false if voter address is valid
	function isVoter(address voterAddress) public view returns (bool) {
		return voters.isVoter(voterAddress);
	}

	function hasVoterVoted() public view returns (bool) {
		return voters.hasVoterVoted(msg.sender);
	}

	// ==============================================================



	// Admin Functions ==============================================

	// Create ballot
	function createBallot(string memory _name) public onlyOwner {
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
	function deleteBallot() public onlyOwner ballotClosed {
		delete ballotsList[currentBallotId];
		ballotsList.pop();
		if (ballotsList.length != 0) {
			currentBallotId--;
		}
	}

	// Open ballot, close ballot
	function openCloseBallot() public onlyOwner {
		if(ballotsList[currentBallotId].status == CLOSED) {
			ballotsList[currentBallotId].status = OPEN;
		} else {
			ballotsList[currentBallotId].status = COMPLETE;
		}
	}

	// Add election
	function addElections(string[][] memory elections) public onlyOwner ballotClosed {
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

	function addIssues(string[] memory issues) public onlyOwner ballotClosed {
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

	// Admin Voter Functions ========================================
	
	/// @notice Adds voter to voting roll & increases total voter count
	/// @param voterAddress Address of voter to add to voter roll
	function addVoter(address voterAddress) public onlyOwner {
		voters.addVoter(voterAddress);
	}

	/// @notice Adds multiple voters to voting roll & increases total voter count
	/// @param voterAddresses Addresses of voters to add to voter roll
	function addMultipleVoters(address[] memory voterAddresses) public onlyOwner {
		voters.addMultipleVoters(voterAddresses);
	}

	/// @notice Removes voter from voting roll & reduces total voter count
	/// @param voterAddress Address of voter to remove from voter roll
	function removeVoter(address voterAddress) public onlyOwner {
		voters.removeVoter(voterAddress);
	}

	/// @notice Removes multiple voters from voting roll & reduces total voter count
	/// @param voterAddresses Addresses of voters to remove from voter roll
	function removeMultipleVoters(address[] memory voterAddresses) public onlyOwner {
		voters.removeMultipleVoters(voterAddresses);
	}

	// ==============================================================


	// Voter Functions ==============================================

	// Vote for all
	// [ [ TYPE , ID , VOTE ]   ]
	// [ [ ELECTION , 0 , VOTE ] ]
	// Election = 0, Issue = 1
	// uint AGAINST = 0;
	// uint FOR = 1;
	function vote(uint[][] memory votes) public onlyOwner {
		require(getCurrentBallotStatus() == 1 && voters.hasVoterVoted(msg.sender) == false);

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
		voters.updateHasVoted(msg.sender);
	}

	// ==============================================================




	// ==============================================================

	// ==============================================================

}
