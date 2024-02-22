/*
    OrgDB Contracts (last update v0.1.0)

*/
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.21;

import {OrgOpBase} from "./base/OrgOpBase.sol";
import {IInit} from "../interfaces/ops/IInit.sol";
import {OnlyRep} from "./access/OnlyRep.sol";


/**
    @title [OrgOp] Init implementation
 */
contract Init is
    IInit,
    OrgOpBase,
    OnlyRep
{
    /**
        !!! Warning !!!
        DO NOT declare storage variables in deps contract. There is a possibility of storage conflict.
        Please refer to the documentation located at "./docs/~~~.md" for more information.
        Instead, please use inheritance with a storage layout contract.
     */
    function init(InitArgs calldata args) public onlyRep(args.pid) {
        // TODO validation
        // VotingStatus storage votingStatus = getRef_VotingStatus();
        // for (uint i; i < votingStatus.nullifierHashes.length; ++i) {
        //     if (args.nullifierHash == votingStatus.nullifierHashes[i]) revert InitAnonSignal_AlreadyInitted();
        // }
        // votingStatus.nullifierHashes.push(args.)
        address anonGroups = ORG_DEPS_ANONGROUPS();
    }
}
