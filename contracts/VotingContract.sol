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
	function getCurrentBallotStatus() public view returns (uint) {
		return ballots.getCurrentBallotStatus();
	}

	// Get current ballot info
	function getCurrentBallot() public view returns (Ballots.Ballot memory) {
		return ballots.getCurrentBallot();
	}

	// List all ballot ids and names
	function getAllBallots() public view returns (Ballots.Ballot[] memory) {
		return ballots.getAllBallots();
	}

	// Get ballot info by id
	function getBallotById(uint _id) external view returns (Ballots.Ballot memory) {
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

	function hasVoterVoted() public view returns (bool) {
		return voters.hasVoterVoted(msg.sender);
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

	// ==============================================================



	// Admin Issue Functions ========================================

	// Add issue
	function addIssues(string[] memory issues) public onlyOwner {
		ballots.addIssues(issues);
	}

	// ==============================================================



	// Voter Functions ==============================================

	// Vote for all
	function vote(uint[][] memory votes) public {
		require(voters.hasVoterVoted(msg.sender) == false);

		ballots.vote(votes);

		voters.updateHasVoted(msg.sender);
	}

	// ==============================================================



	// Admin Ownership Functions ====================================

	// ==============================================================



	// Other Functions ==============================================

	// ==============================================================

}
