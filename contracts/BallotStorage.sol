// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

contract BallotStorage {
	
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

}
