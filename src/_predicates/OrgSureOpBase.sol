// SPDX-License-Identifier: MIT
// OrgDB Contracts (last update v0.1.0)

pragma solidity ^0.8.21;

import {OrgPassOpBase} from "./OrgPassOpBase.sol";

/**

*/
abstract contract orgDBureOpBase is OrgPassOpBase {
    // TODO
    modifier onlySure() {
        _;
    }
}
