// SPDX-License-Identifier: MIT
// OrgDB Contracts (last update v0.1.0)

pragma solidity ^0.8.21;

import {OrgOpBase} from "./base/OrgOpBase.sol";
import {IInitialize} from "../interfaces/ops/IInitialize.sol";

import {OnlyInitiator} from "src/dictionary-pattern/dictionary-user-proxy/OnlyInitiator.sol";
import {WhenInit} from "./access/WhenInit.sol";

/**
    @title [OrgOp] Initialize implementation
 */
contract Initialize is
    IInitialize,
    OrgOpBase,
    OnlyInitiator,
    WhenInit
{
    /**
        !!! Warning !!!
        DO NOT declare storage variables in deps contract. There is a possibility of storage conflict.
        Please refer to the documentation located at "./docs/~~~.md" for more information.
        Instead, please use inheritance with a storage layout contract.
     */
    function initialize(InitializeArgs calldata args) public onlyInitiator whenInit {
        // TODO validation
        // TODO delegatecall to PassOps

        ORG_CONFIGS_METADATA().name = args.orgMetadata.name;
        ORG_CONFIGS_METADATA().explanation = args.orgMetadata.explanation;
        ORG_CONFIGS_METADATA().icon = args.orgMetadata.icon;
        emit OrgMetadataSet(ORG_CONFIGS_METADATA());

        ORG_CONFIGS_VARS().__REPS_PER_DELIBERATION = args.orgVars.__REPS_PER_DELIBERATION;
        ORG_CONFIGS_VARS().__SECONDS_PER_REPS_ENTRY = args.orgVars.__SECONDS_PER_REPS_ENTRY;
        ORG_CONFIGS_VARS().__SECONDS_PER_MEMBERSHIP_MANAGEMENT = args.orgVars.__SECONDS_PER_MEMBERSHIP_MANAGEMENT;
        ORG_CONFIGS_VARS().__DEBT_INCREMENT_FOR_PROPOSE = args.orgVars.__DEBT_INCREMENT_FOR_PROPOSE;
        ORG_CONFIGS_VARS().__DEBT_INCREMENT_WHEN_REP_PICKED = args.orgVars.__DEBT_INCREMENT_WHEN_REP_PICKED;
        ORG_CONFIGS_VARS().__SECONDS_PER_BORDA_SNAPSHOT = args.orgVars.__SECONDS_PER_BORDA_SNAPSHOT;
        ORG_CONFIGS_VARS().__ROUNDS_PER_LEGISLATION = args.orgVars.__ROUNDS_PER_LEGISLATION;
        ORG_CONFIGS_VARS().__ROUNDS_UNTIL_INTERMEDIATE_JUDGETMENT = args.orgVars.__ROUNDS_UNTIL_INTERMEDIATE_JUDGETMENT;
        emit OrgVarsSet(ORG_CONFIGS_VARS());

        ORG_CONFIGS_CONSTS().__MEMBERSHIP_MANAGEMENT_TYPE = args.orgConsts.__MEMBERSHIP_MANAGEMENT_TYPE;
        ORG_CONFIGS_CONSTS().__STOCK_TOKEN = args.orgConsts.__STOCK_TOKEN;
        ORG_CONFIGS_CONSTS().__KEY_CURRENCY = args.orgConsts.__KEY_CURRENCY;
        ORG_CONFIGS_CONSTS().__ORG_CURRENCY = args.orgConsts.__ORG_CURRENCY;
        ORG_CONFIGS_CONSTS().__ORG_OS = args.orgConsts.__ORG_OS;

        ORG_MEMBERS().push(args.sender);
        emit OrgMemberAdded(args.sender);

        // addressStorage[ADDRESS_KEY] = msg.sender;
    }
}
