// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;
//pragma experimental ABIEncoderV2;

import "./VoterStorage.sol";
import "./BallotStorage.sol";

contract VotingContract is BallotStorage, VoterStorage {
	
	struct Administrator {
		/// @notice Address for the administrator
		address adminAddress;
	}

	/// @notice Owner of voting contract
    Administrator administrator;

	constructor() {
		/// @notice On creation set administrator to creator address
		administrator.adminAddress = msg.sender;
	}
	
	/// @param message Error message
	error BallotNotClosed(string message);

	modifier onlyOwner() {
		require(
			msg.sender == administrator.adminAddress,
			"Only Administrator May Call Function"
		);
		_;
	}

	modifier ballotClosed() {
		if (ballotsList.length == 0 || ballotsList[currentBallotId].status != 0) {
			revert BallotNotClosed("Ballot Must Be Created & Closed");
		}
		_;
	}



	/// @notice Get the status of the most recent ballot
	/// @return The ballot status of CLOSED = 0, OPEN = 1, COMPLETE = 2
	function getCurrentBallotStatus() public view returns (uint) {
		require(ballotsList.length > 0, "No Ballot Has Been Created");
		return ballotsList[currentBallotId].status;
	}

	/// @notice Get the most recent ballot
	/// @return Return most recent ballot object
	function getCurrentBallot() public view returns (Ballot memory) {
		require (ballotsList.length > 0, "No Ballot Has Been Created");
		return ballotsList[currentBallotId];
	}

	/// @notice Get list of all ballots
	/// @return A list of ballot objects
	function getAllBallots() public view returns (Ballot[] memory) {
		return ballotsList;
	}

	/// @notice Get ballot information by id
	/// @param _id The id of the ballot to retrieve information from
	/// @return The ballot object of _id
	function getBallotById(uint _id) public view returns (Ballot memory) {
		require (_id < ballotsList.length);
		return (ballotsList[_id]);
	} 

	/// @notice Gets the total voter count in voter roll
	/// @return Total voter count
    function getVoterCount() public view returns (uint) {
        return voterCount;
    }

	/// @notice Returns a boolean for whether or not given address is in voter roll
	/// @return True or false if voter address is valid
	function isVoter(address _voterAddress) public view returns (bool) {
		if (voterRoll[_voterAddress].voterAddress != address(0x0)) {
            return true;
        } else {
            return false;
        }
	}

	/// @notice Check whether or not a voter has voted on current ballot
	function hasVoted(address _voterAddress, uint ballotId) public view returns (bool) {
		return voteRecordList[ballotId].hasVoted[_voterAddress];
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

		voteRecordList.push();
		VoteRecord storage newVoteRecord = voteRecordList[ballotsList.length - 1];
		newVoteRecord.ballotId = currentBallotId;
	}

	// Delete ballot
	function deleteBallot() public onlyOwner ballotClosed {
		delete ballotsList[currentBallotId];
		ballotsList.pop();
		delete voteRecordList[currentBallotId];
		voteRecordList.pop();
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
	/// @param _voterAddress Address of voter to add to voter roll
	function addVoter(address _voterAddress) public onlyOwner {
		Voter memory newVoter = Voter(_voterAddress);
		voterRoll[_voterAddress] = newVoter;
		voterCount = voterCount + 1;
	}

	/// @notice Adds multiple voters to voting roll & increases total voter count
	/// @param voterAddresses Addresses of voters to add to voter roll
	function addMultipleVoters(address[] memory voterAddresses) public onlyOwner {
		for (uint i = 0; i < voterAddresses.length; i++) {
			Voter memory newVoter = Voter(voterAddresses[i]);
			voterRoll[voterAddresses[i]] = newVoter;
			voterCount = voterCount + 1;
		}
	}

	/// @notice Removes voter from voting roll & reduces total voter count
	/// @param _voterAddress Address of voter to remove from voter roll
	function removeVoter(address _voterAddress) public onlyOwner {
		delete voterRoll[_voterAddress];
		voterCount = voterCount - 1;
	}

	/// @notice Removes multiple voters from voting roll & reduces total voter count
	/// @param voterAddresses Addresses of voters to remove from voter roll
	function removeMultipleVoters(address[] memory voterAddresses) public onlyOwner {
		for (uint i = 0; i < voterAddresses.length; i++) {
			delete voterRoll[voterAddresses[i]];
			voterCount = voterCount - 1;
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
	function vote(uint[][] memory votes) public onlyOwner {
		require(getCurrentBallotStatus() == 1 && hasVoted(msg.sender, currentBallotId) == false);

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
		voteRecordList[currentBallotId].hasVoted[msg.sender] = true;
	}

	// ==============================================================

}
