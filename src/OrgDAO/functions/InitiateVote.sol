// SPDX-License-Identifier: MIT
// OrgDB Contracts (last update v0.1.0)

pragma solidity ^0.8.21;

import {console2} from "forge-std/console2.sol";

import {OrgOpBase} from "./base/OrgOpBase.sol";
import {IInitiateVote} from "../interfaces/ops/IInitiateVote.sol";

// import {AddMember} from "./pass/AddMember.sol";
// import {RemoveMember} from "./pass/RemoveMember.sol";
// import {IOrgDB} from "../../org-db/interfaces/IOrgDB.sol";
import {IOrgCurrency} from "../dependencies/OrgCurrency.sol";


/**
    @title [OrgOp] StartDeliberation implementation
 */
contract InitiateVote is
    IInitiateVote,
    OrgOpBase
{

    /**
        !!! Warning !!!
        DO NOT declare storage variables in deps contract. There is a possibility of storage conflict.
        Please refer to the documentation located at "./docs/~~~.md" for more information.
        Instead, please use inheritance with a storage layout contract.
     */

    function initiateVote(InitiateVoteArgs calldata args) public {
        // TODO validation

        Proposal storage proposal = ORG_DELIBERATION_PROPOSALS()[args.pid];
        VotingStatus storage votingStatus = ORG_DELIBERATION_VOTINGSTATUS()[args.pid];

        if (proposal.header.proposalType == ProposalType.MEMBERSHIP_STOCK_TOKEN_RULE) {
            // if (votingStatus.roundStatus[0].ENTRY_EXPIRATION_TIME <= block.timestamp) {
            //     revert EntrySessionNotExpired();
            // }
            // votingStatus.isVotable = true;
            // emit RepsPicked(votingStatus.reps);

            return;
        }
        if (proposal.header.proposalType == ProposalType.MEMBERSHIP_REPS_MAJORITY_RULE) {
            _assignRandomReps({
                votingStatusRef: votingStatus,
                pid: args.pid,
                vrfRequestId: votingStatus.vrfRequestId
            });

            uint256 START_TIME = block.timestamp;
            OrgVars memory orgVars = ORG_CONFIGS_VARS();

            RoundStatus storage roundStatus = votingStatus.roundStatus.push();
            roundStatus.START_TIME = START_TIME;
            // roundStatus.ENTRY_EXPIRATION_TIME = 0;
            roundStatus.EXPIRATION_TIME = START_TIME + orgVars.__SECONDS_PER_MEMBERSHIP_MANAGEMENT;

            // votingStatus.isVotable = true;
            // emit RepsPicked(votingStatus.reps);

            return;
        }
        if (proposal.header.proposalType == ProposalType.LEGISLATION) {
            _assignRandomReps({
                votingStatusRef: votingStatus,
                pid: args.pid,
                vrfRequestId: votingStatus.vrfRequestId
            });

            uint256 START_TIME = block.timestamp;

            // round 0
            RoundStatus storage roundStatus = votingStatus.roundStatus.push();
            roundStatus.START_TIME = START_TIME;
            // roundStatus.ENTRY_EXPIRATION_TIME = 0;
            roundStatus.EXPIRATION_TIME = START_TIME + ORG_CONFIGS_VARS().__SECONDS_PER_BORDA_SNAPSHOT; // TODO

            // votingStatus.isVotable = true;
            // emit RepsPicked(votingStatus.reps);

            emit VoteStarted(args.pid);

            return;
        }
        revert InvalidProposalType();
    }

    function _assignRandomReps(VotingStatus storage votingStatusRef, uint pid, uint256 vrfRequestId) internal returns (address[] memory reps) {
        // Chainlink
        // members
        uint membersCount = ORG_MEMBERS().length; // TODO check delete
        console2.log(membersCount);
        uint repsPerDeliberation = ORG_CONFIGS_VARS().__REPS_PER_DELIBERATION;
        console2.log(repsPerDeliberation);

        uint numToPick = membersCount <= repsPerDeliberation ?
            membersCount : repsPerDeliberation;

        console2.log(numToPick);

        address orgCurrency = ORG_CONFIGS_CONSTS().__ORG_CURRENCY;
        uint incrementDebt = ORG_CONFIGS_VARS().__DEBT_INCREMENT_WHEN_REP_PICKED;

        reps = _pickRandomReps(ORG_MEMBERS(), numToPick);

        for (uint8 i; i < numToPick; ++i) {
            address rep = reps[i];
            votingStatusRef.reps.push(rep);
            IOrgCurrency(orgCurrency).increaseDebt(rep, incrementDebt);
            emit RepAssigned(pid, rep);
        }
    }

    // TODO !!! DANGER !!! MUST change
    function _getRandomIndex(uint memberCount) private returns (uint256) {
            // TODO uint randomNum = ChainlinkVRF(vrfRequestId)
            uint256 randomNumber = uint256(keccak256(abi.encode(block.timestamp))); // TODO
            return randomNumber % memberCount;
    }

    function _pickRandomReps(address[] storage members, uint numToPick) private returns (address[] memory reps) {
        require(members.length >= numToPick, "Not enough members to pick");
        reps = new address[](numToPick);
        uint256 memberCount = members.length;

        for (uint256 i; i < numToPick; i++) {
            uint256 randomIndex = _getRandomIndex(memberCount);
            console2.log(randomIndex);
            reps[i] = members[randomIndex];
            console2.log(reps[i]);
            // Move the last candidate to the randomIndex and reduce the candidateCount to avoid duplicates
            members[randomIndex] = members[memberCount - 1];
            --memberCount;
        }
    }

}
