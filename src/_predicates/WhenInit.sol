// SPDX-License-Identifier: MIT
// OrgDB Contracts (last update v0.1.0)

pragma solidity ^0.8.21;

import {OrgOpBase} from "../base/OrgOpBase.sol";

/**
    @title orgDBOp_Access_WhenInit
 */
abstract contract WhenInit is
    OrgOpBase
{
    /**
        !!! Warning !!!
        DO NOT declare storage variables in deps contract. There is a possibility of storage conflict.
        Please refer to the documentation located at "./docs/~~~.md" for more information.
        Instead, please use inheritance with a storage layout contract.
     */

    error AlreadyInitialized();

    modifier whenInit() {
        if (!_isNotInitialized()) revert AlreadyInitialized();
        _;
        ++ORG_CONFIGS_VARS()._initialized;
    }

    function _isNotInitialized() internal view returns (bool) {
        return ORG_CONFIGS_VARS()._initialized == 0;
    }
}
