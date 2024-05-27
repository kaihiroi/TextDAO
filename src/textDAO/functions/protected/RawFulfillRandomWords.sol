// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import { Storage } from "bundle/textdao/storages/Storage.sol";
import { Schema } from "bundle/textdao/storages/Schema.sol";

contract RawFulfillRandomWords {

    error OnlyCoordinatorCanFulfill(address have, address want);

    // rawFulfillRandomness is called by VRFCoordinator when it receives a valid VRF
    // proof. rawFulfillRandomness then calls fulfillRandomness, after validating
    // the origin of the call
    function rawFulfillRandomWords(uint256 requestId, uint256[] memory randomWords) external {
        address vrfCoordinator = Storage.$VRF().config.vrfCoordinator;
        if (msg.sender != vrfCoordinator) {
            revert OnlyCoordinatorCanFulfill(msg.sender, vrfCoordinator);
        }
        fulfillRandomWords(requestId, randomWords);
    }

    function fulfillRandomWords(uint256 requestId, uint256[] memory randomWordsReturned) internal returns (bool) {
        Schema.VRFStorage storage $vrf = Storage.$VRF();
        Schema.Request storage $r = $vrf.requests[requestId];
        Schema.ProposeStorage storage $prop = Storage.$Proposals();
        Schema.Proposal storage $p = $prop.proposals[$r.proposalId];
        Schema.MemberJoinProtectedStorage storage $member = Storage.$Members();


        uint256[] memory randomWords = randomWordsReturned;

        for (uint i; i < randomWords.length; i++) {
            uint pickedIndex = uint256(randomWords[i]) % $member.nextMemberId;
            $p.proposalMeta.reps[$p.proposalMeta.nextRepId] = $member.members[pickedIndex].addr;
            $p.proposalMeta.nextRepId++;
        }
    }

}
