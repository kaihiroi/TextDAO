// SPDX-License-Identifier: MIT
// OrgDB Contracts (last update v0.1.0)

pragma solidity ^0.8.21;

/**
    Each org operation is registered in orgDB and acts on Org's storage.
 */
import {OrgOpBase} from "./base/OrgOpBase.sol";
import {ISignalMembership} from "../interfaces/ops/ISignalMembership.sol";

import {OnlyRep} from "./access/OnlyRep.sol";



/**
    @title [OrgOp] SignalMembership implementation
 */
contract SignalMembership is ISignalMembership, OrgOpBase, OnlyRep {
    /**
        !!! Warning !!!
        DO NOT declare storage variables in deps contract. There is a possibility of storage conflict.
        Please refer to the documentation located at "./docs/~~~.md" for more information.
        Instead, please use inheritance with a storage layout contract.
     */
    function signalMembership(SignalMembershipArgs calldata args) public onlyRep(args.pid) {
        // TODO validation
        VotingStatus storage votingStatus = ORG_DELIBERATION_VOTINGSTATUS()[args.pid];

        // if (!votingStatus.isVotable) revert NotVotableYet();
        if (block.timestamp < votingStatus.roundStatus[0].START_TIME) revert NotVotableYet();
        if (votingStatus.roundStatus[0].EXPIRATION_TIME < block.timestamp) revert Org_SignalMembership_Expired();

        uint256 stakedAmount = ORG_DELIBERATION_STAKEDSTATUS().stakedAmount[msg.sender];
        if (args.votingWeight <= stakedAmount) {
            votingStatus.membershipSignals[msg.sender] = args.votingWeight;
        }
        revert Org_SignalMembership_ExceedStakedAmount(stakedAmount);
    }
}
