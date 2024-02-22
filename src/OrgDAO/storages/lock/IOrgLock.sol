// SPDX-License-Identifier: MIT
// OrgDB Contracts (last update v0.1.0)

pragma solidity ^0.8.21;

interface IOrgLock {
    struct OrgLock {
        mapping(bytes32 key00 => mapping(address blockHeight => mapping(OpType => uint))) blockOpCounters;
        mapping(bytes32 key01 => bool) isOrgPaused; // TODO consider isOpPaused?
    }

    enum OpType {
        undefined,
        ExecuteBudget,
        ExecuteOp,
        Fork,
        Init,
        InitiateVote,
        Propose,
        SignalMembership,
        SignalZkBorda,
        Stake,
        Tally,
        Unstake
    }
}
