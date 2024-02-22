// SPDX-License-Identifier: MIT
// OrgDB Contracts (last update v0.1.0)

pragma solidity ^0.8.21;

// import {console2 as console} from "forge-std/console2.sol";

import {OrgOpBase} from "./base/OrgOpBase.sol";
import {IGetProposal} from "../interfaces/ops/IGetProposal.sol";


/**
    @title [OrgOp] GetProposal implementation
 */
contract GetProposal is IGetProposal, OrgOpBase {
    /**
        !!! Warning !!!
        DO NOT declare storage variables in deps contract. There is a possibility of storage conflict.
        Please refer to the documentation located at "./docs/~~~.md" for more information.
        Instead, please use inheritance with a storage layout contract.
     */

    function getProposal(uint pid) public view returns (Proposal memory) {
    //     // TODO validation
    //     // TODO consider IProposal
        return ORG_DELIBERATION_PROPOSALS()[pid];
    }
}
