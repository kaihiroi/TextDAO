// SPDX-License-Identifier: MIT
// OrgDB Contracts (last update v0.1.0)

pragma solidity ^0.8.21;

/**
    Each org operation is registered in orgDB and acts on Org's storage.
 */
import {OrgOpBase} from "./base/OrgOpBase.sol";
import {ISignalZkBorda} from "../interfaces/ops/ISignalZkBorda.sol";

import {OnlyRep} from "./access/OnlyRep.sol";

import {IAnonGroups} from "../dependencies/AnonGroups.sol";

/**
    @title [OrgOp] SignalZkBorda implementation
    @notice This function should be called by another EOA
 */
contract SignalZkBorda is ISignalZkBorda, OrgOpBase, OnlyRep {
    /**
        !!! Warning !!!
        DO NOT declare storage variables in deps contract. There is a possibility of storage conflict.
        Please refer to the documentation located at "./docs/~~~.md" for more information.
        Instead, please use inheritance with a storage layout contract.
     */
    function signalZkBorda(SignalZkBordaArgs calldata args) public onlyRep(args.pid) {
        // TODO validation
        VotingStatus storage votingStatus = ORG_DELIBERATION_VOTINGSTATUS()[args.pid];

        // TODO consider eligible time
        // if (!votingStatus.isVotable) revert ZkBordaNotStarted();
        uint startTime = votingStatus.roundStatus[0].START_TIME;
        if (startTime == 0 || block.timestamp < startTime) revert ZkBordaNotStarted();
        if (votingStatus.approvedForkId != 0) revert Org_ZkBorda_AlreadyApproved();

        // TODO validate rank[]
        // o [0,0,0]
        // x [1,1,1]
        // x [10,10,0]
        // Duplicate fork IDs are not allowed in the rank data.

        // TODO Verify
        address anonGroups = ORG_DEPS_ANONGROUPS();
        IAnonGroups(anonGroups).verify(args.pid, args.nullifierHash, args.rank, args.proof);

        bool hasVoted;
        for (uint i; i < votingStatus.nullifierHashes.length; ++i) {
            if (votingStatus.nullifierHashes[i] == args.nullifierHash) {
                hasVoted = true;
                break;
            }
        }
        if (!hasVoted) votingStatus.nullifierHashes.push(args.nullifierHash);

        votingStatus.zkBordaSignals[args.nullifierHash] = args.rank; // TODO
    }
}
