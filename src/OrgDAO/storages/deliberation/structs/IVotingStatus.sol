// SPDX-License-Identifier: MIT
// OrgDB Contracts (last update v0.1.0)

pragma solidity ^0.8.21;

/**
    @dev StorageConflict may happen
 */
interface IVotingStatus {
    struct VotingStatus {
        uint80 approvedForkId;
        RoundStatus[] roundStatus;
        uint256 vrfRequestId;
        address[] reps;
        mapping(address rep => uint256 votingWeight) membershipSignals;
        uint256[] nullifierHashes;
        mapping(uint256 nullifierHash => uint80[3] rank) zkBordaSignals; /// @dev nullifierHash is rep's anon info
    }

    struct RoundStatus {
        uint256 START_TIME;
        uint256 EXPIRATION_TIME;
    }
}
