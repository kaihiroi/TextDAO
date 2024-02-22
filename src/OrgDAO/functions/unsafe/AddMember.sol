// SPDX-License-Identifier: MIT
// OrgDB Contracts (last update v0.1.0)
/// @dev ./docs/specs/NamingConvention.md

pragma solidity ^0.8.21;

// Target Storage
import {OrgPassOpBase} from "../base/OrgPassOpBase.sol";
import {IAddMember} from "../../interfaces/ops/pass/IAddMember.sol";

/**
    @title OrgDBOp_Propose
 */
contract AddMember is IAddMember, OrgPassOpBase {
    /**
        !!! Warning !!!
        DO NOT declare storage variables in deps contract. There is a possibility of storage conflict.
        Please refer to the documentation located at "./docs/~~~.md" for more information.
        Instead, please use inheritance with a storage layout contract.
     */

    function addMember(address member) public {
        // TODO validation
        if (_exist(member)) revert MemberAlreadyExists(member);
        ORG_MEMBERS().push(member);
        emit MemberAdded(member);
    }

    function _exist(address member) internal view returns (bool) {
        address[] memory members = ORG_MEMBERS();
        for (uint i; i < members.length; ++i) {
            if (members[i] == member) return true;
        }
        return false;
    }
}
