// SPDX-License-Identifier: MIT
// OrgDB Contracts (last update v0.1.0)

pragma solidity ^0.8.21;

/**
    Each org operation is registered in orgDB and acts on Org's storage.
 */
import {OrgOpBase} from "./base/OrgOpBase.sol";
import {ISnap} from "../interfaces/ops/ISnap.sol";

import {ITally} from "../interfaces/ops/ITally.sol";

/**
    @title [OrgOp] Snap implementation
 */
contract Snap is ISnap, OrgOpBase {
    /**
        !!! Warning !!!
        DO NOT declare storage variables in deps contract. There is a possibility of storage conflict.
        Please refer to the documentation located at "./docs/~~~.md" for more information.
        Instead, please use inheritance with a storage layout contract.
     */

    // TODO merge into tally
    function snap(SnapArgs calldata args) public {
        // // TODO validation

        // // if (round == __ROUNDS_PER_LEGISLATION) tally();
        // ProposalType proposalType = ORG_DELIBERATION_PROPOSALS()[args.pid].header.proposalType;
        // if (proposalType != ProposalType.LEGISLATION) revert NotLegislation();

        // uint intermediateRound = ORG_CONFIGS_VARS().__ROUNDS_UNTIL_INTERMEDIATE_JUDGETMENT;
        // uint finalRound = ORG_CONFIGS_VARS().__ROUNDS_PER_LEGISLATION;

        // VotingStatus storage votingStatus = ORG_DELIBERATION_VOTINGSTATUS()[args.pid];

        // // Intermediate Judgement
        // if (votingStatus.roundStatus.length == intermediateRound) {
        //     // TODO Slashed if the vote is below half
        // }

        // // TODO
        // // Final Snap
        // if (votingStatus.roundStatus.length == finalRound) {
        //     ITally(address(this)).tally(ITally.TallyArgs({pid: args.pid}));
        //     return;
        // }

        // if (votingStatus.roundStatus.length > finalRound) {
        //     revert LegislationExpired();
        // }

        // RoundStatus storage currentRoundStatus = votingStatus.roundStatus[votingStatus.roundStatus.length - 1];

        // if (block.timestamp < currentRoundStatus.EXPIRATION_TIME) revert RoundNotExpired();

        // votingStatus.roundStatus.push() = RoundStatus({
        //     START_TIME: block.timestamp,
        //     ENTRY_EXPIRATION_TIME: 0,
        //     EXPIRATION_TIME: block.timestamp + ORG_CONFIGS_VARS().__SECONDS_PER_BORDA_SNAPSHOT
        // });

        // emit Snapped(args.pid, votingStatus.roundStatus.length - 1, 0,0,0); // TODO
    }
}
