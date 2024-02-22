// SPDX-License-Identifier: MIT
// OrgDB Contracts (last update v0.1.0)

pragma solidity ^0.8.21;

import {IBudget} from "./structs/IBudget.sol";
import {IDoc} from "./structs/IDoc.sol";

interface IOrgDecisions is
    IBudget,
    IDoc
{
    struct OrgDecisions {
        mapping(bytes32 key00 => Budget[]) budgets;
        mapping(bytes32 key01 => Doc[]) docs;
    }
}
