// SPDX-License-Identifier: MIT
// OrgDB Contracts (last update v0.1.0)

pragma solidity ^0.8.21;

/**
    Each org operation is registered in orgDB and acts on Org's storage.
 */
import {OrgOpBase} from "./base/OrgOpBase.sol";
import {IRepayDebt} from "../interfaces/ops/IRepayDebt.sol";

/**
    @title [OrgOp] RepayDebt implementation
 */
contract RepayDebt is IRepayDebt, OrgOpBase {
    /**
        !!! Warning !!!
        DO NOT declare storage variables in deps contract. There is a possibility of storage conflict.
        Please refer to the documentation located at "./docs/~~~.md" for more information.
        Instead, please use inheritance with a storage layout contract.
     */
    function repayDebt(RepayDebtArgs calldata args) public {
        // TODO validation
        // orgProposals[_ORG_PROPOSALS_KEY].push();
    }
}
