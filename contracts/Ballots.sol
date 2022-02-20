// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "./VotingContract.sol";

contract Ballots {
	struct CandidateStruct {
		uint id;
		string name;
		uint votes;
	}

	struct ElectionStruct {
		uint id;
		string name;
		uint currentCandidateId;
		CandidateStruct[] candidates;
		mapping(address => bool) hasVoted;
	}

	struct IssueSruct {
		uint id;
		string name;
		uint forVotes;
		uint againstVotes;
		bool isPassed;
		mapping(address => bool) hasVoted;
	}

	struct Ballot {
		uint status;
		uint id;
		string name;
		uint currentElectionId;
		uint currentIssueId;
		ElectionStruct[] elections;
		IssueSruct[] issues;
	}

	/// @notice State of ballot variables for Ballot.status
	uint constant closed = 0;
	uint constant open = 1;
	uint constant completed = 2;
	uint constant doesNotExist = 3;

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

    modifier onlyOwner() {
		if (msg.sender != address(owner)) {
			revert NotOwner("Only Owner May Call Function");
		}
		_;
	}



	// ==============================================================

	// Functions ====================================================

	// ==============================================================



	// Info Functions ===============================================
	
	// Get current ballot status

	// Get current ballot info

	// List all ballot ids and names

	// Get ballot info by id


	// ==============================================================



	// Admin Ballot Functions =======================================

	// Create ballot

	// Delete ballot

	// Change name of ballot

	// Open ballot, close ballot

	// ==============================================================



	// Admin Election Functions =====================================

	// Add election

	// Delete election

	// Change name of election

	// Add candidate

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
