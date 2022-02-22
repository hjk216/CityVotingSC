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
	modifier onlyOwner() {
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
	function getCurrentBallotStatus() public view onlyOwner returns (uint) {
		return ballots.getCurrentBallotStatus();
	}

	// Get current ballot info

	// List all ballot ids and names

	// Get ballot info by id
	function getBallotById(uint _id) external view onlyOwner returns (Ballots.Ballot memory) {
		return ballots.getBallotById(_id);
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



	// Admin Ballot Functions =======================================

	// Create ballot
	function createBallot(string memory _name) public onlyOwner {
		ballots.createBallot(_name);
	}

	// Delete ballot
	function deleteBallot() public onlyOwner {
		ballots.deleteBallot();
	}

	// Change name of ballot
	function changeNameBallot(string memory newName) public onlyOwner {
		ballots.changeNameBallot(newName);
	}

	// Open ballot, close ballot
	function openCloseBallot() public onlyOwner {
		ballots.openCloseBallot();
	}

	// ==============================================================



	// Admin Election Functions =====================================

	// Add election
	function addElections(string[][] memory elections) public onlyOwner {
		ballots.addElections(elections);
	}

	/*
	[
		['1','2'],
		['3','4']
	]
	 */



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


	
	struct TestStruct {
		uint id;
		string name;
		string message;
	}

	TestStruct[] testStructs;

	function createTest(uint _id, string memory _name, string memory _message) public {
		TestStruct memory newTestStruct = TestStruct(_id, _name, _message);
		testStructs.push(newTestStruct);
	}

	function getTest(uint _id) public view returns (TestStruct memory) {
		return testStructs[_id];
	}

}
