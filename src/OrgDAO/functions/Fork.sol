// SPDX-License-Identifier: MIT
// OrgDB Contracts (last update v0.1.0)

pragma solidity ^0.8.21;

import {OrgOpBase} from "./base/OrgOpBase.sol";
import {IFork} from "../interfaces/ops/IFork.sol";

import {OnlyParticipant} from "./access/OnlyParticipant.sol";



/**
    @title [OrgOp] Fork implementation
 */
contract Fork is
    IFork,
    OrgOpBase,
    OnlyParticipant
{
    /**
        !!! Warning !!!
        DO NOT declare storage variables in deps contract. There is a possibility of storage conflict.
        Please refer to the documentation located at "./docs/~~~.md" for more information.
        Instead, please use inheritance with a storage layout contract.
     */
    function fork(ForkArgs calldata args) public onlyParticipant() {
        // TODO validation
        Proposal storage proposal = ORG_DELIBERATION_PROPOSALS()[args.pid];
        ProposalBody storage fork = proposal.forks.push();
            fork.targetFid = args.fid;
            fork.overview = Overview({
                problem: args.problem,
                harm: args.harm,
                cause: args.cause
            });
            fork.solutions.push() = ExecutableOp({
                executed: 0,
                data: args.opData
            });

        emit NewFork(fork, msg.sender);
    }
}
