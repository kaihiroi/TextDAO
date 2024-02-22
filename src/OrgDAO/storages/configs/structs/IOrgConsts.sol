// SPDX-License-Identifier: MIT
// OrgDB Contracts (last update v0.1.0)

pragma solidity ^0.8.21;

/**
    @dev StorageConflict may happen
 */
interface IOrgConsts {
    /// @dev Naming Conventing (docs/specs/NamingConvention.md)
    /* solhint-disable var-name-mixedcase */
    struct OrgConsts {
        MembershipManagementType __MEMBERSHIP_MANAGEMENT_TYPE;
        address __STOCK_TOKEN; /// @dev should be immutable
        address __KEY_CURRENCY; /// @dev should be immutable
        address __ORG_CURRENCY;
        address __ORG_OS;
    }
    /* solhint-enable var-name-mixedcase */

    enum MembershipManagementType {
        Undefined,
        STOCK_TOKEN_RULE,
        REPS_MAJORITY_RULE
    }
}
