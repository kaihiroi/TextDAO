// SPDX-License-Identifier: MIT
// OrgDB Contracts (last update v0.1.0)

pragma solidity ^0.8.21;

/**
    Each org operation is registered in orgDB and acts on Org's storage.
 */
import {OrgOpBase} from "./base/OrgOpBase.sol";
import {IStake} from "../interfaces/ops/IStake.sol";
import {IERC20} from "@openzeppelin/token/ERC20/IERC20.sol";



/**
    @title [OrgOp] Stake implementation
 */
contract Stake is IStake, OrgOpBase {
    /**
        !!! Warning !!!
        DO NOT declare storage variables in deps contract. There is a possibility of storage conflict.
        Please refer to the documentation located at "./docs/~~~.md" for more information.
        Instead, please use inheritance with a storage layout contract.
     */
    function stake(StakeArgs calldata args) public {
        // TODO validation

        StakedStatus storage stakedStatus = ORG_DELIBERATION_STAKEDSTATUS();

        address stockToken = ORG_CONFIGS_CONSTS().__STOCK_TOKEN;
        if (IERC20(stockToken).transferFrom(msg.sender, address(this), args.amount)) {
            stakedStatus.stakedAmount[msg.sender] += args.amount;
            if (!_exist(msg.sender)) stakedStatus.stakers.push(msg.sender);
            // stakedStatus.totalStaked += args.amount;
            emit Org_Staked(msg.sender, args.amount);
            return;
        }
        revert Org_Stake_FAILED();
    }

    function _exist(address staker) internal view returns (bool) {
        address[] memory stakers = ORG_DELIBERATION_STAKEDSTATUS().stakers;
        for (uint i; i < stakers.length; ++i) {
            if (stakers[i] == staker) return true;
        }
        return false;
    }

}
