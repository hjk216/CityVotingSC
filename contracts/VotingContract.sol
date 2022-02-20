// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;
//pragma experimental ABIEncoderV2;

import "./Voters.sol";
import "./Ballots.sol";

//import "./Election.sol";

contract VotingContract {
	struct Administrator {
		/// @notice Address for the administrator
		address adminAddress;
	}

	/// @notice Owner of voting contract
    Administrator administrator;

	/// @notice List of ballots
	Ballots ballots;

	/// @notice Voter storage and functions
	Voters voters;

	constructor() {
		/// @notice On creation set administrator to creator address
		administrator.adminAddress = msg.sender;

		voters = new Voters();

		ballots = new Ballots();

	}

	// Error Messages
	error NotAdmin(string message);
	error BallotNotClosed(string message);

	
	// Modifiers
	modifier onlyAdmin() {
		if (msg.sender != administrator.adminAddress) {
			revert NotAdmin("Only Administrator May Call Function");
		}
		_;
	}

	/*
	modifier ballotIsClosed() {
		if (currentBallotStatus() != 0) {
			revert BallotNotClosed("Ballot Must Be Created And Closed");
		}
		_;
	}
	*/
	
	// Events
	event TestEvent(
		string message
	);

	// Info Functions ===============================================

	// Get current ballot status

	// Get current ballot info

	// List all ballot ids and names

	// Get ballot info by id

	// Get voter count

	// isVoter

	// ==============================================================



	// Admin Voter Functions ========================================

	// Add voter

	// Add multiple voters

	// Remove voter

	// Remove multiple voters

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

	// Vote status (to see if voter has voted on each issue & election)

	// Vote for issue

	// Vote for election

	// Vote for all

	// ==============================================================



	// Admin Ownership Functions ====================================

	// ==============================================================



	// Other Functions ==============================================

	// ==============================================================



	// Testing ======================================================
	
	// ==============================================================

	struct Election2 {
		string name;
	}

	struct Issue2 {
		string name;
	}

	struct Ballot2 { 
		string name;
		mapping (uint => Issue2) issues;
	}

	struct Ballot3 {
		string name;
		string[] messages;
		Issue2[] issues;
	}

	uint ballotId;

	//Ballot2[] ballots2;
	mapping (uint => Ballot2) ballots2;
	mapping (uint => Ballot3) ballots3;

	function popStruct() public {
		Ballot2 storage newBallot2 = ballots2[0];
		newBallot2.name = "hello world";

		Ballot3 storage newBallot3 = ballots3[0];
		newBallot3.name = "hi";

		string memory aString = "world";
		newBallot3.messages.push(aString);

		Issue2 memory newIssue2 = Issue2("hey");
		newBallot3.issues.push(newIssue2);

	}

	

}
