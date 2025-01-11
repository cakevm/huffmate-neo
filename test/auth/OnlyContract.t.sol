// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {Test} from "forge-std/Test.sol";

import {HuffNeoDeployer} from "foundry-huff-neo/HuffNeoDeployer.sol";
import {HuffNeoConfig} from "foundry-huff-neo/HuffNeoConfig.sol";

contract OnlyContractTest is Test {
    address only_contract;

    function setUp() public {
        HuffNeoConfig config = HuffNeoDeployer.config();
        only_contract = config.deploy("test/auth/mocks/OnlyContractWrappers.huff");
    }

    /// @notice Tests that ONLY_CONTRACT macro reverts when tx.origin == msg.sender
    function testOnlyContract(address caller) public {
        // foundry's tx.origin = 0x00a329c0648769A73afAc7F9381E08FB43dBEA72
        vm.assume(caller != tx.origin);

        // Should revert when tx.origin == msg.sender
        // vm.startPrank(address,address) sets msg.sender and tx.origin
        vm.startPrank(caller, caller);
        vm.expectRevert();
        only_contract.call("");
        vm.stopPrank();

        // Only setting the msg.sender and not tx.origin should succeed, so long as
        // caller != 0x00a329c0648769A73afAc7F9381E08FB43dBEA72, which is the default tx.origin
        vm.startPrank(caller);
        (bool success,) = only_contract.call("");
        assert(success);
        vm.stopPrank();
    }
}
