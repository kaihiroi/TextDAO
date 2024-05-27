// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {MCTest} from "@devkit/Flattened.sol";

import { Fork } from "bundle/textdao/functions/Fork.sol";
import { Storage } from "bundle/textdao/storages/Storage.sol";
import { Schema } from "bundle/textdao/storages/Schema.sol";
import { Types } from "bundle/textdao/storages/Types.sol";

contract ForkTest is MCTest {

    function setUp() public {
        _use(Fork.fork.selector, address(new Fork()));
    }

    function test_fork() public {
        uint pid = 0;
        Schema.ProposeStorage storage $ = Storage.$Proposals();
        Schema.Proposal storage $p = $.proposals[pid];

        Types.ProposalArg memory p;
        p.header.metadataURI = "Qc.....xh";
        p.cmd.actions = new Schema.Action[](1);

        $p.proposalMeta.reps.push(); // array init
        $p.proposalMeta.reps[0] = address(this);

        assertEq($p.headers.length, 0);
        assertEq($p.cmds.length, 0);
        uint forkId = Fork(address(this)).fork(pid, p);
        assertEq($p.headers.length, 1);
        assertEq($p.cmds.length, 1);
    }

}
