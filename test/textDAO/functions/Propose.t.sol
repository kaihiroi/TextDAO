// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {MCTest} from "@devkit/Flattened.sol";

import { Propose } from "bundle/textdao/functions/protected/Propose.sol";
import { Storage } from "bundle/textdao/storages/Storage.sol";
import { Schema } from "bundle/textdao/storages/Schema.sol";
import { Types } from "bundle/textdao/storages/Types.sol";
import "@chainlink/vrf/interfaces/VRFCoordinatorV2Interface.sol";

import {ProtectionBase} from "bundle/textDAO/functions/protected/protection/ProtectionBase.sol";

contract ProposeTest is MCTest {

    function setUp() public {
        _use(Propose.propose.selector, address(new Propose()));
    }

    function test_propose() public {
        Schema.MemberJoinProtectedStorage storage $m = Storage.$Members();
        Schema.VRFStorage storage $vrf = Storage.$VRF();

        $m.nextMemberId = 1;
        $m.members[0].addr = address(this);

        $vrf.subscriptionId = uint64(1);
        $vrf.config.vrfCoordinator = address(1);
        $vrf.config.keyHash = bytes32(uint256(1));
        $vrf.config.callbackGasLimit = uint32(1);
        $vrf.config.requestConfirmations = uint16(1);
        $vrf.config.numWords = uint32(1);
        $vrf.config.LINKTOKEN = address(1);
        vm.mockCall(
            $vrf.config.vrfCoordinator,
            abi.encodeWithSelector(VRFCoordinatorV2Interface.requestRandomWords.selector),
            abi.encode(1)
        );

        Types.ProposalArg memory p;
        p.header.metadataURI = "Qc.....xh";

        uint pid = Propose(address(this)).propose(p);
        Schema.Proposal storage $p = Storage.$Proposals().proposals[pid];

        assertEq(pid, 0);
        assertEq($p.proposalMeta.headerRank.length, 0);
        assertEq($p.proposalMeta.cmdRank.length, 0);
        assertEq($p.headers[0].metadataURI, p.header.metadataURI);
    }

}
