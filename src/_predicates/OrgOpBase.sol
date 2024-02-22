// SPDX-License-Identifier: MIT
// OrgDB Contracts (last update v0.1.0)

pragma solidity ^0.8.21;

import {OrgProxyStorageLayout} from "../../storage-layout/OrgProxyStorageLayout.sol";

/// @dev The information about this exception is documented in (docs/specs/Operation.md)
/// @dev Storage Interface
abstract contract OrgOpBase is OrgProxyStorageLayout {
    // Common Error
    error Org_UnknownError();

    OrgStorage internal org;

    /**
        !!! Warning !!!
        DO NOT declare storage variables in deps contract. There is a possibility of storage conflict.
        Please refer to the documentation located at "./docs/~~~.md" for more information.
        Instead, please use inheritance with a storage layout contract.
     */

    /// TODO onlyProxy etc.


    // Configs
    function ORG_CONFIGS() internal view returns (OrgConfigs storage) {
        return org.configs[_ORG_CONFIGS];
    }

    function ORG_CONFIGS_METADATA() internal view returns (OrgMetadata storage) {
        return org.configs[_ORG_CONFIGS].metadata[_ORG_CONFIGS_METADATA];
    }

    function ORG_CONFIGS_VARS() internal view returns (OrgVars storage) {
        return org.configs[_ORG_CONFIGS].vars[_ORG_CONFIGS_VARS];
    }

    function ORG_CONFIGS_CONSTS() internal view returns (OrgConsts storage) {
        return org.configs[_ORG_CONFIGS].consts[_ORG_CONFIGS_CONSTS];
    }

    // Members
    function ORG_MEMBERS() internal view returns (address[] storage) {
        return org.members[_ORG_MEMBERS];
    }

    // Departments
    function ORG_DEPS() internal view returns (OrgDepartments storage) {
        return org.deps[_ORG_DEPARTMENTS];
    }

    function ORG_DEPS_FORKS() internal view returns (address[] storage) {
        return org.deps[_ORG_DEPARTMENTS].forks[_ORG_DEPARTMENTS_FORKS];
    }

    function ORG_DEPS_ANONGROUPS() internal view returns (address) {
        return org.deps[_ORG_DEPARTMENTS].anonGroups[_ORG_DEPARTMENTS_ANONGROUPS];
    }

    // Deliberation
    function ORG_DELIBERATION() internal view returns (OrgDeliberation storage) {
        return org.deliberation[_ORG_DELIBERATION];
    }

    function ORG_DELIBERATION_PROPOSALS() internal view returns (Proposal[] storage) {
        return org.deliberation[_ORG_DELIBERATION].proposals[_ORG_DELIBERATION_PROPOSALS];
    }

    function ORG_DELIBERATION_VOTINGSTATUS() internal view returns (mapping(uint pid => VotingStatus) storage) {
        return org.deliberation[_ORG_DELIBERATION].votingStatus[_ORG_DELIBERATION_VOTINGSTATUS];
    }

    function ORG_DELIBERATION_STAKEDSTATUS() internal view returns (StakedStatus storage) {
        return org.deliberation[_ORG_DELIBERATION].stakedStatus[_ORG_DELIBERATION_STAKEDSTATUS];
    }

    // Decisions
    function ORG_DECISIONS() internal view returns (OrgDecisions storage) {
        return org.decisions[_ORG_DECISIONS];
    }

    function ORG_DECISIONS_BUDGETS() internal view returns (Budget[] storage) {
        return org.decisions[_ORG_DECISIONS].budgets[_ORG_DECISIONS_BUDGETS];
    }

    function ORG_DECISIONS_DOCS() internal view returns (Doc[] storage) {
        return org.decisions[_ORG_DECISIONS].docs[_ORG_DECISIONS_DOCS];
    }

    // Finance
    function ORG_FINANCE() internal view returns (OrgFinance storage) {
        return org.finance[_ORG_FINANCE];
    }

    function ORG_FINANCE_RECEIVED() internal view returns (mapping(address sender => uint256) storage) {
        return org.finance[_ORG_FINANCE].received[_ORG_FINANCE_RECEIVED];
    }

    function ORG_FINANCE_PROPOSALDEPOSIT() internal view returns (mapping(address proposer => mapping(uint pid => uint256)) storage) {
        return org.finance[_ORG_FINANCE].proposalDeposit[_ORG_FINANCE_PROPOSALDEPOSIT];
    }

    // Lock
    function ORG_LOCK() internal view returns (OrgLock storage) {
        return org.lock[_ORG_LOCK];
    }

    function ORG_LOCK_BLOCKOPCOUNTERS() internal view returns (mapping(address blockHeight => mapping(OpType => uint)) storage) {
        return org.lock[_ORG_LOCK].blockOpCounters[_ORG_LOCK_BLOCKOPCOUNTERS];
    }

    function ORG_LOCK_ISORGPAUSED() internal view returns (bool) {
        return org.lock[_ORG_LOCK].isOrgPaused[_ORG_LOCK_ISORGPAUSED];
    }


    // Common Functions
    fallback() external payable {
        ORG_FINANCE_RECEIVED()[msg.sender] = msg.value;
    }

    receive() external payable {} // TODO
}
