// SPDX-License-Identifier: MIT
// OrgDB Contracts (last update v0.1.0)

pragma solidity ^0.8.21;

/**
    @dev StorageConflict may happen
 */
interface IProposal {
    struct Proposal {
        ProposalHeader header;
        ProposalBody[] forks;
    }

    struct ProposalHeader {
        address proposer;
        ProposalType proposalType;
    }

    enum ProposalType {
        Undefined,
        MEMBERSHIP_STOCK_TOKEN_RULE,
        MEMBERSHIP_REPS_MAJORITY_RULE,
        LEGISLATION
    }

    /// @dev Forkable Part
    struct ProposalBody {
        uint80 targetFid;
        Overview overview;
        ExecutableOp[] solutions;
    }

    struct Overview {
        string problem;
        string harm;
        string cause;
    }

    struct ExecutableOp {
        uint executed;
        bytes data;
    }
}
