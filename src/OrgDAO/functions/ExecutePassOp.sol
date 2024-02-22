/** https://patorjk.com/software/taag/#p=display&f=Slant&t=ExecuteBudget

@title OrgDB Org Operation - ExecutePassOp
    ______                     __       ____                  ____
   / ____/  _____  _______  __/ /____  / __ \____ ___________/ __ \____
  / __/ | |/_/ _ \/ ___/ / / / __/ _ \/ /_/ / __ `/ ___/ ___/ / / / __ \
 / /____>  </  __/ /__/ /_/ / /_/  __/ ____/ /_/ (__  |__  ) /_/ / /_/ /
/_____/_/|_|\___/\___/\__,_/\__/\___/_/    \__,_/____/____/\____/ .___/
                                                               /_/
*/
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.21;

/// @dev Only Dev
// import {console2 as console} from "forge-std/console2.sol";

import {OrgOpBase} from "./base/OrgOpBase.sol";
import {IExecutePassOp} from "../interfaces/ops/IExecutePassOp.sol";

// import {IOrgDB} from "src/org-db/interfaces/IOrgDB.sol";

import {IDictionary} from "src/dictionary-pattern/dictionary/IDictionary.sol";

/**
    @title [OrgOp] ExecutePassOp implementation
 */
contract ExecutePassOp is
    IExecutePassOp,
    OrgOpBase
{
    /**
        !!! Warning !!!
        DO NOT declare storage variables in deps contract. There is a possibility of storage conflict.
        Please refer to the documentation located at "./docs/~~~.md" for more information.
        Instead, please use inheritance with a storage layout contract.
     */

    function executePassOp(ExecutePassOpArgs calldata args) public {

        // TODO uint80 fid = votingStatus.approvedForkId;

        uint80 approvedForkId = ORG_DELIBERATION_VOTINGSTATUS()[args.pid].approvedForkId;

        if (approvedForkId == 0) revert NotApprovedYet();

        ExecutableOp memory op = ORG_DELIBERATION_PROPOSALS()[args.pid].forks[approvedForkId].solutions[args.oid];
        address opImpl = IDictionary(_dictionary()).getPassOp(bytes4(op.data));
        (bool success, bytes memory result) = opImpl.delegatecall(op.data);
        if (!success) {
            if (result.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly.
                assembly {
                    let resultSize := mload(result)
                    revert(add(32, result), resultSize)
                }
            } else {
                revert UnknownError();
            }
        }
    }

}
