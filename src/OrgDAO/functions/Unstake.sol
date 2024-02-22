// SPDX-License-Identifier: MIT
// OrgDB Contracts (last update v0.1.0)

pragma solidity ^0.8.21;

/**
    Each org operation is registered in orgDB and acts on Org's storage.
 */
import {OrgOpBase} from "./base/OrgOpBase.sol";
import {IUnstake} from "../interfaces/ops/IUnstake.sol";
import {IERC20} from "@openzeppelin/token/ERC20/IERC20.sol";



/**
    @title [OrgOp] Stake implementation
 */
contract Unstake is IUnstake, OrgOpBase {
    /**
        !!! Warning !!!
        DO NOT declare storage variables in deps contract. There is a possibility of storage conflict.
        Please refer to the documentation located at "./docs/~~~.md" for more information.
        Instead, please use inheritance with a storage layout contract.
     */
    function unstake(UnstakeArgs calldata args) public {
        // TODO validation
        // TODO !!!!! DANGER: external account access !!!!!

        StakedStatus storage stakedStatus = ORG_DELIBERATION_STAKEDSTATUS();

        if (stakedStatus.stakedAmount[msg.sender] > args.amount) revert Org_Unstake_ExceedStakedAmount();


        address stockToken = ORG_CONFIGS_CONSTS().__STOCK_TOKEN;
        if (IERC20(stockToken).transfer(msg.sender, args.amount)) {
            stakedStatus.stakedAmount[msg.sender] -= args.amount;
            // stakedStatus.totalStaked -= args.amount;
            // TODO if amount == 0, then remove from stakers
            emit Org_Unstaked(msg.sender, args.amount);
        }
        revert Org_Unstake_FAILED();
    }
}
