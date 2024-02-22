// SPDX-License-Identifier: MIT
// OrgDB Contracts (last update v0.1.0)

pragma solidity ^0.8.21;

/**
    @dev StorageConflict may happen
 */
interface IOrgVars {
    /// @dev Naming Conventing (docs/specs/NamingConvention.md)
    /* solhint-disable var-name-mixedcase */
    struct OrgVars {
        // MembershipManagementType __MEMBERSHIP_MANAGEMENT_TYPE;
        uint _initialized;
        uint __REPS_PER_DELIBERATION;
        uint __SECONDS_PER_REPS_ENTRY; // TODO validate __SECONDS_PER_REPS_ENTRY + orgDB.MARGIN <= __SECONDS_PER_MEMBERSHIP_MANAGEMENT
        uint __SECONDS_PER_MEMBERSHIP_MANAGEMENT;
        uint __DEBT_INCREMENT_FOR_PROPOSE;
        uint __DEBT_INCREMENT_WHEN_REP_PICKED;

        uint __SECONDS_PER_BORDA_SNAPSHOT;
        uint __ROUNDS_PER_LEGISLATION;
        uint __ROUNDS_UNTIL_INTERMEDIATE_JUDGETMENT;

        uint __STOCK_TOKEN_MINIMAL_STAKE;
    }
    /* solhint-enable var-name-mixedcase */
}
