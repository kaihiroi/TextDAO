// SPDX-License-Identifier: MIT
// OrgDB Contracts (last update v0.1.0)

pragma solidity ^0.8.21;

interface IOrgFinance {
    struct OrgFinance {
        mapping(bytes32 key00 => mapping(address sender => uint256 amount)) received;
        mapping(bytes32 key01 => mapping(address proposer => mapping(uint pid => uint256))) proposalDeposit;
    }
}
