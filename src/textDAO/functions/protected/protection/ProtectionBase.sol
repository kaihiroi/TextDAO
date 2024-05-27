// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import { Storage } from "bundle/textdao/storages/Storage.sol";
import { Schema } from "bundle/textdao/storages/Schema.sol";

contract ProtectionBase {

    /// @dev Write your own reusable protection (e.g., for DAO, for AA wallets, for onlyOwner, for token holders and stakers)
    modifier protected(uint pid) {
        Schema.ProposeStorage storage $ = Storage.$Proposals();
        Schema.Proposal storage $p = $.proposals[pid];
        require($p.proposalMeta.createdAt + $.config.expiryDuration < block.timestamp && $p.proposalMeta.headerRank.length > 0, "Corresponding proposal must be expired and tallied.");
        _;
    }

    modifier onlyMember() {
        Schema.MemberJoinProtectedStorage storage $member = Storage.$Members();

        bool result;

        for (uint i; i < $member.nextMemberId; i++) {
            result = $member.members[i].addr == msg.sender || result;
        }
        require(result, "You are not the member.");
        _;
    }

}
