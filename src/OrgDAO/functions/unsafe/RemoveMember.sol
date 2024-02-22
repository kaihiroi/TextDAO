// SPDX-License-Identifier: MIT
// OrgDB Contracts (last update v0.1.0)

pragma solidity ^0.8.21;

// Target Storage
// import {S03_MembersStorage} from "../../storage-layout/state-vars/S03_MembersStorage.sol";
import {OrgPassOpBase} from "../base/OrgPassOpBase.sol";
import {IRemoveMember} from "../../interfaces/ops/pass/IRemoveMember.sol";

/**
    @title RemoveMember implementation
 */
contract RemoveMember is IRemoveMember, OrgPassOpBase {
    /**
        !!! Warning !!!
        DO NOT declare storage variables in deps contract. There is a possibility of storage conflict.
        Please refer to the documentation located at "./docs/~~~.md" for more information.
        Instead, please use inheritance with a storage layout contract.
     */

    function removeMember(address member) public {
        // TODO validation
        // TODO at least 1 member
        // if 0 then revert or set orgDB as member[0]
        address[] storage members = ORG_MEMBERS();
        for (uint256 i; i < members.length; i++) {
            if (members[i] == member) {
                delete members[i];
                emit MemberRemoved(member);
                break;
            }
        }
    }
}
