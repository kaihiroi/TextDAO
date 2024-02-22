// SPDX-License-Identifier: MIT
// OrgDB Contracts (last update v0.1.0)

pragma solidity ^0.8.21;

import {OrgOpBase} from "../base/OrgOpBase.sol";

/**
    @title OrgOp_Access_OnlyRep
 */
abstract contract OnlyRep is
    OrgOpBase
{
    /**
        !!! Warning !!!
        DO NOT declare storage variables in deps contract. There is a possibility of storage conflict.
        Please refer to the documentation located at "./docs/~~~.md" for more information.
        Instead, please use inheritance with a storage layout contract.
     */

    error YouAreNotRep();

    modifier onlyRep(uint pid) { // TODO
        if (!isRep(msg.sender, pid)) revert YouAreNotRep();
        _;
    }

    function isRep(address sender, uint pid) public view returns (bool) {
        // return org.votingStatus[_ORG_VOTINGSTATUS_KEY][pid].reps[sender].votingWeight != 0;
        address[] memory reps = ORG_DELIBERATION_VOTINGSTATUS()[pid].reps;
        for (uint256 i; i < reps.length;) {
            if (reps[i] == sender) return true;
            unchecked {
                ++i;
            }
        }
        return false;
    }
}
