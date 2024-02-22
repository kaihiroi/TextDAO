// SPDX-License-Identifier: MIT
// OrgDB Contracts (last update v0.1.0)

pragma solidity ^0.8.21;

// Target Storage
import {OrgPassOpBase} from "../base/OrgPassOpBase.sol";
import {IRemoveBudget} from "../../interfaces/ops/pass/IRemoveBudget.sol";

/**
    @title OrgDBOp_Propose
 */
contract RemoveBudget is IRemoveBudget, OrgPassOpBase {
    /**
        !!! Warning !!!
        DO NOT declare storage variables in deps contract. There is a possibility of storage conflict.
        Please refer to the documentation located at "./docs/~~~.md" for more information.
        Instead, please use inheritance with a storage layout contract.
     */

    event BudgetRemoved(Budget budget);

    function removeBudget(uint bid) public {
        // TODO validation
        delete ORG_DECISIONS_BUDGETS()[bid];
    }
}
