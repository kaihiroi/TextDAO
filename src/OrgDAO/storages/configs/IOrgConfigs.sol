// SPDX-License-Identifier: MIT
// OrgDB Contracts (last update v0.1.0)

pragma solidity ^0.8.21;

import {IOrgMetadata} from "./structs/IOrgMetadata.sol";
import {IOrgVars} from "./structs/IOrgVars.sol";
import {IOrgConsts} from "./structs/IOrgConsts.sol";

interface IOrgConfigs is
    IOrgMetadata,
    IOrgVars,
    IOrgConsts
{
    struct OrgConfigs {
        mapping(bytes32 key00 => OrgMetadata) metadata;
        mapping(bytes32 key01 => OrgVars) vars;
        mapping(bytes32 key02 => OrgConsts) consts;
    }
}
