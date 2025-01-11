// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "foundry-huff-neo/HuffNeoConfig.sol";
import "forge-std/Test.sol";

interface TSOwnable {
    function owner() external view returns (address);
    function pendingOwner() external view returns (address);
    function setPendingOwner(address) external;
    function acceptOwnership() external;
}

contract TSOwnableTest is Test {
    TSOwnable tsOwnable;
    address huffConfig;

    function setUp() public {
        // Deploy TSOwnable
        huffConfig = address(new HuffNeoConfig());
        tsOwnable = TSOwnable(
            HuffNeoConfig(huffConfig)
                .deploy("test/utils/mocks/TSOwnableWrappers.huff")
        );
    }

    function testTsOwnableGetOwner() public {
        assertEq(tsOwnable.owner(), huffConfig);
    }

    function testTsOwnableSetPendingOwner(address rando) public {
        vm.assume(rando != huffConfig);

        vm.startPrank(rando);
        vm.expectRevert("ONLY_OWNER");
        tsOwnable.setPendingOwner(address(0xBEEF));
        vm.stopPrank();

        vm.prank(huffConfig);
        tsOwnable.setPendingOwner(address(0xBEEF));

        assertEq(tsOwnable.pendingOwner(), address(0xBEEF));
    }

    function testTsOwnableSetAndAcceptOwner(address rando) public {
        vm.assume(rando != address(0xBEEF));

        vm.prank(huffConfig);
        tsOwnable.setPendingOwner(address(0xBEEF));
        assertEq(tsOwnable.pendingOwner(), address(0xBEEF));

        // Random person shouldn't be able to accept ownership
        vm.startPrank(rando);
        vm.expectRevert("ONLY_PENDING_OWNER");
        tsOwnable.acceptOwnership();
        vm.stopPrank();

        vm.prank(address(0xBEEF));
        tsOwnable.acceptOwnership();
        assertEq(tsOwnable.owner(), address(0xBEEF));
        assertEq(tsOwnable.pendingOwner(), address(0));

        vm.startPrank(address(0xBEEF));
        vm.expectRevert("ALREADY_OWNER");
        tsOwnable.setPendingOwner(address(0xBEEF));
        vm.stopPrank();

    }
}