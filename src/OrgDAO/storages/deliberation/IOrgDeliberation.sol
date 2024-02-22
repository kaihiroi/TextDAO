// SPDX-License-Identifier: MIT
// OrgDB Contracts (last update v0.1.0)

pragma solidity ^0.8.21;

import {IProposal} from "./structs/IProposal.sol";
import {IVotingStatus} from "./structs/IVotingStatus.sol";
import {IStakedStatus} from "./structs/IStakedStatus.sol";

interface IOrgDeliberation is
    IProposal,
    IVotingStatus,
    IStakedStatus
{
    struct OrgDeliberation {
        mapping(bytes32 key00 => Proposal[]) proposals;
        mapping(bytes32 key01 => mapping(uint pid => VotingStatus)) votingStatus;
        mapping(bytes32 key02 => StakedStatus) stakedStatus;
    }
}
