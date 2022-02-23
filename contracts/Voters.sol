// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "./VotingContract.sol";

contract Voters {
    struct Voter {
		/// @notice Address of registered voter
		address voterAddress;
		bool hasVoted;
	}

    /// @notice Total number of registered voters
	uint voterCount;

    /// @notice Voting roll of all registered voters
	mapping(address => Voter) public voterRoll;

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



    /// @notice Gets the total voter count in voter roll
	/// @return Total voter count
    function getVoterCount() external view returns (uint) {
        return voterCount;
    }

    /// @notice Returns a boolean for whether or not given address is in voter roll
	/// @return True or false if voter address is valid
    function isVoter(address _voterAddress) external view returns (bool) {
        if (voterRoll[_voterAddress].voterAddress != address(0x0)) {
            return true;
        } else {
            return false;
        }
    }

	function hasVoterVoted(address _voterAddress) external view onlyOwner returns (bool) {
		return voterRoll[_voterAddress].hasVoted;
	}



    /// @notice Adds voter to voting roll & increases total voter count
	/// @param _voterAddress Address of voter to add to voter roll
	function addVoter(address _voterAddress) external onlyOwner {
		Voter memory newVoter = Voter(_voterAddress, false);
		voterRoll[_voterAddress] = newVoter;
		voterCount = voterCount + 1;
	}

	/// @notice Adds multiple voters to voting roll & increases total voter count
	/// @param voterAddresses Addresses of voters to add to voter roll
	function addMultipleVoters(address[] memory voterAddresses) external onlyOwner {
		for (uint i = 0; i < voterAddresses.length; i++) {
			Voter memory newVoter = Voter(voterAddresses[i], false);
			voterRoll[voterAddresses[i]] = newVoter;
			voterCount = voterCount + 1;
		}
	}

	/// @notice Removes voter from voting roll & reduces total voter count
	/// @param _voterAddress Address of voter to remove from voter roll
	function removeVoter(address _voterAddress) external onlyOwner {
		delete voterRoll[_voterAddress];
		voterCount = voterCount - 1;
	}

	/// @notice Removes multiple voters from voting roll & reduces total voter count
	/// @param voterAddresses Addresses of voters to remove from voter roll
	function removeMultipleVoters(address[] memory voterAddresses) external onlyOwner {
		for (uint i = 0; i < voterAddresses.length; i++) {
			delete voterRoll[voterAddresses[i]];
			voterCount = voterCount - 1;
		}
	}

	function updateHasVoted(address _voterAddress) external onlyOwner {
		voterRoll[_voterAddress].hasVoted = true;
	}

}
