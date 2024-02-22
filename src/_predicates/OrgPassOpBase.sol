// SPDX-License-Identifier: MIT
// OrgDB Contracts (last update v0.1.0)

pragma solidity ^0.8.21;

import {OrgOpBase} from "./OrgOpBase.sol";

/**

*/
abstract contract OrgPassOpBase is OrgOpBase {
    // TODO
    modifier onlyPassed() {
        _;
    }
}
