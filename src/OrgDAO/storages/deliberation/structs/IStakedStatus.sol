// SPDX-License-Identifier: MIT
// OrgDB Contracts (last update v0.1.0)

pragma solidity ^0.8.21;

/**
    @dev StorageConflict may happen
 */
interface IStakedStatus {
    struct StakedStatus {
        // uint256 totalStaked;
        address[] stakers;
        mapping(address staker => uint256) stakedAmount;
    }
}
