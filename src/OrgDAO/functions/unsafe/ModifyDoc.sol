// SPDX-License-Identifier: MIT
// OrgDB Contracts (last update v0.1.0)

pragma solidity ^0.8.21;

// Target Storage
import {OrgPassOpBase} from "../base/OrgPassOpBase.sol";
import {IModifyDoc} from "../../interfaces/ops/pass/IModifyDoc.sol";

/**
    @title OrgDBOp_Propose
 */
contract ModifyDoc is IModifyDoc, OrgPassOpBase {
    /**
        !!! Warning !!!
        DO NOT declare storage variables in deps contract. There is a possibility of storage conflict.
        Please refer to the documentation located at "./docs/~~~.md" for more information.
        Instead, please use inheritance with a storage layout contract.
     */


    function modifyDoc(uint cid, Doc calldata newDoc) public {
        // TODO validation
        ORG_DECISIONS_DOCS()[cid] = newDoc;
        emit DocModified(cid, newDoc);
    }
}
