/** https://patorjk.com/software/taag/#p=display&f=Slant&t=ExecuteBudget

@title OrgDB Org Operation - ExecuteBudget
    ______                     __       ____            __           __
   / ____/  _____  _______  __/ /____  / __ )__  ______/ /___ ____  / /_
  / __/ | |/_/ _ \/ ___/ / / / __/ _ \/ __  / / / / __  / __ `/ _ \/ __/
 / /____>  </  __/ /__/ /_/ / /_/  __/ /_/ / /_/ / /_/ / /_/ /  __/ /_
/_____/_/|_|\___/\___/\__,_/\__/\___/_____/\__,_/\__,_/\__, /\___/\__/
                                                      /____/

    last updated v0.1.0
*/
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.21;

/// @dev Only Dev
// import "forge-std/console2.sol";

import {OrgOpBase} from "./base/OrgOpBase.sol";
import {IExecuteBudget} from "../interfaces/ops/IExecuteBudget.sol";

import {IERC20} from "@openzeppelin/token/ERC20/IERC20.sol";

/**
    @title [OrgOp] ExecuteBudget implementation
 */
contract ExecuteBudget is IExecuteBudget, OrgOpBase {
    /**
        !!! Warning !!!
        DO NOT declare storage variables in deps contract. There is a possibility of storage conflict.
        Please refer to the documentation located at "./docs/~~~.md" for more information.
        Instead, please use inheritance with a storage layout contract.
     */

    function executeBudget(ExecuteBudgetArgs calldata args) public {
        BudgetBody memory budget = ORG_DECISIONS_BUDGETS()[args.bid].bodies[args.bodyIndex];

        if (block.timestamp < budget.vestingStart) revert VestingNotStarted(budget.vestingStart);
        uint256 transferrableAmount =
            budget.amount * (block.timestamp - budget.vestingStart) / budget.vestingDuration <= budget.amount ?
            budget.amount * (block.timestamp - budget.vestingStart) / budget.vestingDuration :
            budget.amount;

        IERC20(budget.currencyUnit).transfer(budget.manager, transferrableAmount);
    }

}
