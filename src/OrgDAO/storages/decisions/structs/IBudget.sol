// SPDX-License-Identifier: MIT
// OrgDB Contracts (last update v0.1.0)

pragma solidity ^0.8.21;

/**
    @dev StorageConflict may happen
 */
interface IBudget {
    struct Budget {
        BudgetHeader header;
        BudgetBody[] bodies;
    }

    struct BudgetHeader {
        string title;
        string summary;
    }

    struct BudgetBody {
        address currencyUnit;
        uint256 amount;
        uint256 vestingStart; // Cliff
        uint256 vestingDuration;
        address manager;
    }
}
