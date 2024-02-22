// SPDX-License-Identifier: MIT
// OrgDB Contracts (last update v0.1.0)

pragma solidity ^0.8.21;

interface IOrgDepartments {
    struct OrgDepartments {
        mapping(bytes32 key00 => address[]) forks;
        mapping(bytes32 key01 => address) anonGroups;
    }
}
