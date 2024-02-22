// SPDX-License-Identifier: MIT
// OrgDB Contracts (last update v0.1.0)

pragma solidity ^0.8.21;

import {console2} from "forge-std/console2.sol";

/**
    Each org operation is registered in orgDB and acts on Org's storage.
 */
import {OrgOpBase} from "./base/OrgOpBase.sol";
import {ITally} from "../interfaces/ops/ITally.sol";
import {FlashLock} from "./access/FlashLock.sol";

import {IERC20} from "@openzeppelin/token/ERC20/IERC20.sol";

/**
    @title [OrgOp] Tally implementation
 */
contract Tally is ITally, OrgOpBase, FlashLock {
    /**
        !!! Warning !!!
        DO NOT declare storage variables in deps contract. There is a possibility of storage conflict.
        Please refer to the documentation located at "./docs/~~~.md" for more information.
        Instead, please use inheritance with a storage layout contract.
     */

    struct ZkBordaVars {
        uint currentRound;
        uint intermediateRound;
        uint finalPotentialRound;
        uint forksLength;
    }

    /// TODO consider flashLock (tally with stake, unstake, etc)
    function tally(TallyArgs calldata args) public flashLock() {
        // TODO validation
        Proposal storage proposal = ORG_DELIBERATION_PROPOSALS()[args.pid];


        ProposalType proposalType = proposal.header.proposalType;
        VotingStatus storage votingStatus = ORG_DELIBERATION_VOTINGSTATUS()[args.pid];

        // MembershipManagement - STOCK TOKEN RULE
        if (proposalType == ProposalType.MEMBERSHIP_STOCK_TOKEN_RULE) {
            // Expiration Check
            /// @dev There is only 1 round in MembershipManagement.
            _expirationCheck(votingStatus, 1);

            StakedStatus storage stakedStatus = ORG_DELIBERATION_STAKEDSTATUS();
            address[] memory stakers = stakedStatus.stakers;

            // Aggregate score & totalStakedAmount
            uint score;
            uint256 totalStakedAmount;
            for (uint i; i < stakers.length; ++i) {
                uint256 _votingWeight = votingStatus.membershipSignals[stakers[i]];
                uint256 _stakedAmount = stakedStatus.stakedAmount[stakers[i]];
                if (_stakedAmount < _votingWeight) revert OrgOp_Tally_InvalidVotingPower();
                totalStakedAmount += _stakedAmount;
                score += _votingWeight;
            }
            if (totalStakedAmount < score) revert OrgOp_Tally_InvalidScore();

            // Calculate threshold
            uint threshold = _calcMajority(totalStakedAmount);

            // Derive result
            if (threshold <= score) { // TODO consider lt or le
                votingStatus.approvedForkId = 1;
                emit ProposalApproved(args.pid, 1, threshold, score);
                return;
            } else {
                emit ProposalRejected(args.pid, threshold, score);
                return;
            }
        }

        // MembershipManagement - REPS MAJORITY RULE
        if (proposalType == ProposalType.MEMBERSHIP_REPS_MAJORITY_RULE) {
            // Expiration Check
            /// @dev There is only 1 round in MembershipManagement.
            _expirationCheck(votingStatus, 1);

            address[] memory reps = votingStatus.reps;

            // Aggregate score
            uint score;
            for (uint i; i < reps.length; ++i) {
                uint256 _votingWeight = votingStatus.membershipSignals[reps[i]];
                if (_votingWeight != 1) revert OrgOp_Tally_InvalidVotingPower();
                score += 1;
            }

            // Calculate threshold
            uint threshold = _calcMajority(reps.length);

            // Derive result
            if (threshold <= score) { // TODO consider lt or le
                votingStatus.approvedForkId = 1;
                emit ProposalApproved(args.pid, 1, threshold, score);
                return;
            } else {
                emit ProposalRejected(args.pid, threshold, score);
                return;
            }
        }

        // LEGISLATION - ZK BORDA RULE
        if (proposalType == ProposalType.LEGISLATION) {
            /// @dev avoid stack too deep
            ZkBordaVars memory vars;

            vars.currentRound = votingStatus.roundStatus.length;

            // Expiration Check
            _expirationCheck(votingStatus, vars.currentRound);

            vars.intermediateRound = ORG_CONFIGS_VARS().__ROUNDS_UNTIL_INTERMEDIATE_JUDGETMENT;
            vars.finalPotentialRound = ORG_CONFIGS_VARS().__ROUNDS_PER_LEGISLATION;
            vars.forksLength = proposal.forks.length;

            // Before the final potential round - Borda Snapshot
            if (vars.currentRound < vars.finalPotentialRound) {
                // Potentially subject to slashing in intermediate round.
                bool shouldRefund;
                if (vars.currentRound == vars.intermediateRound) {
                    /// @dev _intermediateJudgement() returns whether it has been slashed or not.
                    if (_intermediateJudgement(votingStatus, args.pid)) {
                        return;
                    } else {
                        shouldRefund = true;
                    }
                }

                // Aggregate borda scores.
                uint[] memory scores = _aggregateBordaScores(votingStatus, vars.forksLength);

                /// Search top forks.
                /// @dev The length of scores MUST be at least 2.
                /// @dev scores[0] MUST be 0.
                (
                    uint bestScore, uint80[] memory bestScoreForkIds,
                    uint secondScore, uint80[] memory secondScoreForkIds,
                    uint thirdScore, uint80[] memory thirdScoreForkIds
                ) = _searchTopForkIds(scores);

                // Take snapshot.
                emit BordaSnapshot(
                    args.pid,
                    vars.currentRound,
                    bestScore, bestScoreForkIds,
                    secondScore, secondScoreForkIds,
                    thirdScore, thirdScoreForkIds
                );

                // Start next round.
                _startNextRound(args.pid, votingStatus);

                // Refund if not slashed.
                if (shouldRefund) _refund(args.pid);

                // Finalize the tally for this round.
                return;
            }

            // From the final potential round - Approve the best fork
            if (vars.currentRound >= vars.finalPotentialRound) {
                // Aggregate borda scores.
                uint[] memory scores = _aggregateBordaScores(votingStatus, vars.forksLength);

                // Find the best score & its fork ids.
                /// @dev The length of scores MUST be at least 2.
                /// @dev scores[0] MUST be 0.
                (uint bestScore, uint80[] memory bestScoreForkIds) = _findBestScoreForkIds(scores);

                // Tiebreaker will be triggered if there are multiple best score forks.
                if (bestScoreForkIds.length != 1) {
                    // Emit the tiebreaker event.
                    emit Tiebreaker(args.pid, vars.currentRound, bestScore, bestScoreForkIds);

                    // Start additional round.
                    _startNextRound(args.pid, votingStatus);

                    // Finalize the tally for this round.
                    return;
                }

                // Approve the best fork & Emit event.
                votingStatus.approvedForkId = bestScoreForkIds[0];
                emit ProposalApproved(args.pid, bestScoreForkIds[0]);

                // Finalize the tally for this round.
                return;
            }

        }

        revert OrgOp_Tally_UnknownProposalType();
    }

    /**
        Expire
     */
    function _expirationCheck(VotingStatus storage votingStatus, uint currentRound) internal view {
        uint256 expirationTime = votingStatus.roundStatus[currentRound - 1].EXPIRATION_TIME;
        if (block.timestamp < expirationTime) revert OrgOp_Tally_RoundNotExpired();
    }

    /**
        @notice Aggregate scores for each fork.
        @dev scores index == forks index
        TODO MUST validate the existence of ForkId in signal registration.
     */
    function _aggregateBordaScores(VotingStatus storage votingStatus, uint forksLength) internal returns (uint256[] memory) {
        uint[] memory scores = new uint[](forksLength);

        uint256[] memory nullifierHashes = votingStatus.nullifierHashes;

        for (uint i; i < nullifierHashes.length; ++i) {
            uint80[3] memory _rank = votingStatus.zkBordaSignals[nullifierHashes[i]];
            if (_rank[0] != 0) scores[_rank[0]] += 3;
            if (_rank[1] != 0) scores[_rank[1]] += 2;
            if (_rank[2] != 0) scores[_rank[2]] += 1;
        }

        return scores;
    }

    function _startNextRound(uint pid, VotingStatus storage votingStatus) internal {
        votingStatus.roundStatus.push() = RoundStatus({
            START_TIME: block.timestamp,
            // ENTRY_EXPIRATION_TIME: 0,
            EXPIRATION_TIME: block.timestamp + ORG_CONFIGS_VARS().__SECONDS_PER_BORDA_SNAPSHOT
        });
        emit NewRoundStarted(pid, votingStatus.roundStatus.length);
    }


    /// If the number of votes does not exceed a majority of reps, this Proposal will be slashed.
    /// @return hasSlashed whether it has been slashed or not. Slashed: true, Refund: false
    function _intermediateJudgement(VotingStatus storage votingStatus, uint pid) internal returns (bool hasSlashed) {
        uint256[] memory nullifierHashes = votingStatus.nullifierHashes;

        // Aggregate the number of votes
        uint votedNullifierHashes;
        for (uint i; i < nullifierHashes.length; ++i) {
            uint80[3] memory rank = votingStatus.zkBordaSignals[nullifierHashes[i]];
            if (!(rank[0] == 0 && rank[1] == 0 && rank[2] == 0)) ++votedNullifierHashes;
        }

        // Calculate threshold
        /// @dev Threshold is calculated based on the number of voting authorities (reps).
        uint threshold = _calcMajority(votingStatus.reps.length);

        // Derive result
        if (votedNullifierHashes < threshold) {
            // votingStatus.isVotable = false;
            emit Slashed(pid, threshold, votedNullifierHashes);
            hasSlashed = true;
        } else {
            emit IntermediateJudgementPassed(pid, threshold, votedNullifierHashes);
            hasSlashed = false;
        }
    }

    // TODO IMPORTANT check carefully
    function _refund(uint pid) internal {
        address proposer = ORG_DELIBERATION_PROPOSALS()[pid].header.proposer;
        uint256 amount = ORG_FINANCE_PROPOSALDEPOSIT()[proposer][pid];
        delete ORG_FINANCE_PROPOSALDEPOSIT()[proposer][pid];
        IERC20(ORG_CONFIGS_CONSTS().__ORG_CURRENCY).transfer(proposer, amount);
    }

    /// Search the top score & fork ids from the given score.
    /// @param scores The input array of uint values. The first value is always 0.
    // @return The array of indexes corresponding to the top values in the input array.
    function _searchTopForkIds(uint[] memory scores) public pure returns (
        uint bestScore, uint80[] memory bestScoreForkIds,
        uint secondScore, uint80[] memory secondScoreForkIds,
        uint thirdScore, uint80[] memory thirdScoreForkIds
    ) {
        uint bestCount;
        uint secondCount;
        uint thirdCount;

        for (uint i = 1; i < scores.length; i++) {
            if (scores[i] > bestScore) {
                thirdScore = secondScore;
                secondScore = bestScore;
                bestScore = scores[i];

                thirdCount = secondCount;
                secondCount = bestCount;
                bestCount = 1;
            } else if (scores[i] == bestScore) {
                bestCount++;
            } else if (scores[i] > secondScore) {
                thirdScore = secondScore;
                secondScore = scores[i];

                thirdCount = secondCount;
                secondCount = 1;
            } else if (scores[i] == secondScore) {
                secondCount++;
            } else if (scores[i] > thirdScore) {
                thirdScore = scores[i];
                thirdCount = 1;
            } else if (scores[i] == thirdScore) {
                thirdCount++;
            }
        }

        bestScoreForkIds = new uint80[](bestCount);
        secondScoreForkIds = new uint80[](secondCount);
        thirdScoreForkIds = new uint80[](thirdCount);

        uint j;
        uint k;
        uint l;

        for (uint80 i = 1; i < scores.length; ++i) {
            if (scores[i] == bestScore) {
                bestScoreForkIds[j] = i;
                j++;
            } else if (scores[i] == secondScore) {
                secondScoreForkIds[k] = i;
                k++;
            } else if (scores[i] == thirdScore) {
                thirdScoreForkIds[l] = i;
                l++;
            }
        }
    }


    ///
    ///
    function _findBestScoreForkIds(uint[] memory scores)
        internal
        pure
        returns (
            uint bestScore, uint80[] memory bestScoreForkIds
        )
    {
        bestScore = scores[1];
        uint80[] memory tempBestScoreForkIds = new uint80[](scores.length);
        uint count = 1;
        tempBestScoreForkIds[0] = 1;

        for (uint80 i = 2; i < scores.length; ++i) {
            if (scores[i] > bestScore) {
                // New bestScore found, reset the count & forkIds
                bestScore = scores[i];
                tempBestScoreForkIds[0] = i;
                count = 1;
            } else if (scores[i] == bestScore) {
                // Same bestScore found, add index to the list.
                tempBestScoreForkIds[count] = i;
                ++count;
            }
        }

        uint80[] memory bestScoreForkIds = new uint80[](count);
        for (uint i; i < count; ++i) {
            bestScoreForkIds[i] = tempBestScoreForkIds[i];
        }

        return (bestScore, bestScoreForkIds);
    }

    function _calcMajority(uint256 number) internal pure returns (uint256) {
        return number / 2 + number % 2;
    }
}
