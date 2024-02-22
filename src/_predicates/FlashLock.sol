// SPDX-License-Identifier: MIT
// OrgDB Contracts (last update v0.1.0)

pragma solidity ^0.8.21;

import {OrgOpBase} from "../base/OrgOpBase.sol";


/**
    @title OrgOp_Access_OnlyPassed
 */
abstract contract FlashLock is
    OrgOpBase
{
    /**
        !!! Warning !!!
        DO NOT declare storage variables in deps contract. There is a possibility of storage conflict.
        Please refer to the documentation located at "./docs/~~~.md" for more information.
        Instead, please use inheritance with a storage layout contract.
     */

    error OrgAccess_();

    modifier flashLock() {
        // if (!isMember(msg.sender)) revert NotApproved();
        _;
    }

    // function isMember(address sender) public view returns (bool) {
    //     address[] memory members = ORG_MEMBERS();
    //     for (uint256 i; i < members.length;) {
    //         if (members[i] == sender) return true;
    //         unchecked {
    //             i++;
    //         }
    //     }
    //     return false;
    // }
}
