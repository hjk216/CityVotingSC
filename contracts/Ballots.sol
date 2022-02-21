// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "./VotingContract.sol";
import "./Strings.sol";

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
		mapping(address => bool) hasVoted;
	}

	struct Issue {
		uint id;
		string name;
		uint forVotes;
		uint againstVotes;
		bool isPassed;
		mapping(address => bool) hasVoted;
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
	function getCurrentBallotStatus() external view onlyOwner returns (uint) {
		require(ballotsList.length > 0);
		return ballotsList[currentBallotId].status;
	}

	// Get current ballot info

	// List all ballot ids and names

	// Get ballot info by id
	function getBallotById(uint _id) external view onlyOwner returns (
		uint, 
		string memory,
		uint//,
		//string[][] memory
	) {
		require (_id >= 0 && _id < ballotsList.length);
		// string[][] memory electionsList;

		// for (uint i = 0; i < ballotsList[_id].elections.length; i++) {

		// }

		return (
			_id, 
			ballotsList[_id].name, 
			ballotsList[_id].status
		);
	} 


	// ==============================================================



	// Admin Ballot Functions =======================================

	// Create ballot
	function createBallot(string memory _name) external onlyOwner {
		require(ballotsList.length == 0 || ballotsList[currentBallotId].status == COMPLETE);
		ballotsList.push();
		Ballot storage newBallot = ballotsList[ballotsList.length - 1];
		if(ballotsList.length != 0) { currentBallotId++; }

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

	// Change name of ballot
	function changeNameBallot(string memory newName) external onlyOwner ballotClosed {
		ballotsList[currentBallotId].name = newName;
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
	function addElections(string[] memory electionNames) external onlyOwner ballotClosed {
		for (uint i = 0; i < electionNames.length; i++) {
			ballotsList[currentBallotId].elections.push();
			Election storage newElection = ballotsList[currentBallotId].elections[ballotsList[currentBallotId].elections.length - 1];
			if (ballotsList[currentBallotId].elections.length != 0) { ballotsList[currentBallotId].currentElectionId++; }
			
			newElection.id = ballotsList[currentBallotId].currentElectionId;
			newElection.name = electionNames[i];
			newElection.currentCandidateId = 0;
		}
	}

	// Delete election
	/// @dev Leaves space in elections array
	function deleteElectionById(uint _id) external onlyOwner ballotClosed {
		delete ballotsList[currentBallotId].elections[_id];
	}

	// Change name of election
	function changeNameElectionById(uint _id, string memory newName) external onlyOwner ballotClosed {
		ballotsList[currentBallotId].elections[_id].name = newName;
	}

	// Add candidates
	function addCandidates(uint _id, string[] memory candidateNames) external onlyOwner ballotClosed {

	}

	// Delete candidate

	// ==============================================================



	// Admin Issue Functions ========================================

	// Add issue

	// Delete issue

	// Change name of issue

	// ==============================================================



	// Voter Functions ==============================================

	// Vote status

	// Vote for issue

	// Vote for election

	// Vote for all

	// ==============================================================



	// Other Functions ==============================================

	// ==============================================================



}
