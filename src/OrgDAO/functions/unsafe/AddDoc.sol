// SPDX-License-Identifier: MIT
// OrgDB Contracts (last update v0.1.0)

pragma solidity ^0.8.21;

// Target Storage
import {OrgPassOpBase} from "../base/OrgPassOpBase.sol";

import {IAddDoc} from "../../interfaces/ops/pass/IAddDoc.sol";

/**
    @title OrgDBOp_Propose
 */
contract AddDoc is IAddDoc, OrgPassOpBase {
    /**
        !!! Warning !!!
        DO NOT declare storage variables in deps contract. There is a possibility of storage conflict.
        Please refer to the documentation located at "./docs/~~~.md" for more information.
        Instead, please use inheritance with a storage layout contract.
     */

    function addDoc(Doc calldata doc) public {
        // TODO validation
        ORG_DECISIONS_DOCS().push(doc);
        emit DocAdded(doc);
    }
}
