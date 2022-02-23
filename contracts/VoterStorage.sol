// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

//import "./VotingContract.sol";

contract VoterStorage {
    struct Voter {
		/// @notice Address of registered voter
		address voterAddress;
	}

	struct VoteRecord {
		uint ballotId;
		mapping(address => bool) hasVoted;
	}

    /// @notice Total number of registered voters
	uint voterCount;

    /// @notice Voting roll of all registered voters
	mapping(address => Voter) public voterRoll;

	VoteRecord[] voteRecordList;

}
