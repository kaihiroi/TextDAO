// SPDX-License-Identifier: MIT
// OrgDB Contracts (last update v0.1.0)

pragma solidity ^0.8.21;

// Target Storage
import {OrgPassOpBase} from "../base/OrgPassOpBase.sol";

import {IAddBudget} from "../../interfaces/ops/pass/IAddBudget.sol";


/**
    @title OrgPassOp_AddBudget
 */
contract AddBudget is IAddBudget, OrgPassOpBase {
    /**
        !!! Warning !!!
        DO NOT declare storage variables in deps contract. There is a possibility of storage conflict.
        Please refer to the documentation located at "./docs/~~~.md" for more information.
        Instead, please use inheritance with a storage layout contract.
     */

    function addBudget(Budget calldata budget) public {
        // TODO validation
        ORG_DECISIONS_BUDGETS().push(budget);
        emit BudgetAdded(budget);
    }
}
