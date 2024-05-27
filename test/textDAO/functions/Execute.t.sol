// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {MCTest} from "@devkit/Flattened.sol";

import { Execute } from "bundle/textdao/functions/Execute.sol";
import { Storage } from "bundle/textdao/storages/Storage.sol";
import { Schema } from "bundle/textdao/storages/Schema.sol";

contract ExecuteTest is MCTest {

    function setUp() public {
        _use(Execute.execute.selector, address(new Execute()));
    }

    function test_execute_success() public {
        uint pid = 0;
        Schema.Proposal storage $p = Storage.$Proposals().proposals[pid];
        $p.cmds.push();
        $p.proposalMeta.cmdRank = new uint[](3);

        Execute(address(this)).execute(pid);
    }

}
