// SPDX-License-Identifier: MIT
// OrgDB Contracts (last update v0.1.0)

pragma solidity ^0.8.21;

import {console2} from "forge-std/console2.sol";

import {OrgOpBase} from "./base/OrgOpBase.sol";
import {IPropose} from "../interfaces/ops/IPropose.sol";

import {OnlyMember} from "./access/OnlyMember.sol";

import {IAddMember} from "./pass/AddMember.sol";
import {IRemoveMember} from "./pass/RemoveMember.sol";

import {IOrgCurrency} from "../dependencies/OrgCurrency.sol";

/**
    @title [OrgOp] Propose implementation
 */
contract Propose is
    IPropose,
    OrgOpBase,
    OnlyMember
{

    /**
        !!! Warning !!!
        DO NOT declare storage variables in deps contract. There is a possibility of storage conflict.
        Please refer to the documentation located at "./docs/~~~.md" for more information.
        Instead, please use inheritance with a storage layout contract.
     */

    function propose(ProposeArgs calldata args) public payable onlyMember {
        // TODO validation
        OrgVars memory orgVars = ORG_CONFIGS_VARS();
        OrgConsts memory orgConsts = ORG_CONFIGS_CONSTS();

        ProposalType proposalType = _determineProposalType(args.opDatas, orgVars, orgConsts);

        Proposal[] storage proposals = ORG_DELIBERATION_PROPOSALS();
        uint pid = proposals.length;

        Proposal storage proposal = proposals.push();


        /**
            ProposalHeader
         */
        proposal.header.proposalType = proposalType;
        proposal.header.proposer = msg.sender;


        /**
            Prepare voting
         */
        VotingStatus storage votingStatus = ORG_DELIBERATION_VOTINGSTATUS()[pid];
        if (proposalType == ProposalType.MEMBERSHIP_STOCK_TOKEN_RULE) {
            RoundStatus storage roundStatus = votingStatus.roundStatus.push();
            roundStatus.START_TIME = block.timestamp;
            // roundStatus.ENTRY_EXPIRATION_TIME = block.timestamp + orgVars.__SECONDS_PER_REPS_ENTRY;
            roundStatus.EXPIRATION_TIME = block.timestamp + orgVars.__SECONDS_PER_MEMBERSHIP_MANAGEMENT;
        }
        if (proposalType == ProposalType.MEMBERSHIP_REPS_MAJORITY_RULE) {
            // Chainlink VRF
            // proposal.header.vrfRequestId = requestRandomWords()
            votingStatus.vrfRequestId = 100; // TODO
        }
        if (proposalType == ProposalType.LEGISLATION) {
            // Chainlink VRF
            // proposal.header.vrfRequestId = requestRandomWords()
            votingStatus.vrfRequestId = 200; // TODO
        }


        /**
            Body (fork)
         */
        _initProposalBody(proposal, args);


        /**
            Increase Debt
         */
        uint debtAmount = orgVars.__DEBT_INCREMENT_FOR_PROPOSE;
        console2.log(debtAmount);
        ORG_FINANCE_PROPOSALDEPOSIT()[msg.sender][pid] = debtAmount;
        IOrgCurrency(ORG_CONFIGS_CONSTS().__ORG_CURRENCY).increaseDebt(msg.sender, debtAmount);


        emit WaitingForRepsPick(pid, votingStatus.vrfRequestId);
    }

    function _determineProposalType(bytes[] memory opDatas, OrgVars memory orgVars, OrgConsts memory orgConsts) internal pure returns (ProposalType) {
        // To determine whether the ProposalType is MembershipManagement or Legislation from the OpDatas.
        bool isMembership;
        bool isLegislation;
        for (uint i; i < opDatas.length; ++i) {
            if (_isMembershipProposal(bytes4(opDatas[i]))) {
                isMembership = true;
            } else {
                isLegislation = true;
            }
            if (isMembership == isLegislation) revert MultiProposalTypesNotAllowed();
        }

        // If it's Legislation, it will be returned as it is.
        if (isLegislation) return ProposalType.LEGISLATION;

        // If it's Membership Management, it will read the values from OrgVars to determine the Membership ManagementType.
        if (isMembership) {
            MembershipManagementType orgMembershipManagementType = orgConsts.__MEMBERSHIP_MANAGEMENT_TYPE;
            if (orgMembershipManagementType == MembershipManagementType.STOCK_TOKEN_RULE) {
                return ProposalType.MEMBERSHIP_STOCK_TOKEN_RULE;
            }
            if (orgMembershipManagementType == MembershipManagementType.REPS_MAJORITY_RULE) {
                return ProposalType.MEMBERSHIP_REPS_MAJORITY_RULE;
            }
            revert UnknownMembershipManagementType();
        }

        /// @dev This process is unlikely to be reached, but it is provided as a risk hedge for future changes.
        revert UnknownProposalType();
    }

    function _isMembershipProposal(bytes4 sig) internal pure returns (bool) {
        return (
            sig == IAddMember.addMember.selector ||
            sig == IRemoveMember.removeMember.selector
        );
    }

    function _initProposalBody(Proposal storage proposal, ProposeArgs memory args) internal {
        proposal.forks.push(); /// @dev forkId starts 1
        ProposalBody storage fork = proposal.forks.push();
            fork.targetFid = 0;
            fork.overview = args.overview;
            for (uint i; i < args.opDatas.length; ++i) {
                fork.solutions.push().data = args.opDatas[i];
            }
    }

}
