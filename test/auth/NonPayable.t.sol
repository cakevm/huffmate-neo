// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import {HuffNeoDeployer} from "foundry-huff-neo/HuffNeoDeployer.sol";
import {HuffNeoConfig} from "foundry-huff-neo/HuffNeoConfig.sol";

contract NonPayableTest is Test {
  address np;

  function setUp() public {
    HuffNeoConfig config = HuffNeoDeployer.config();
    np = config.deploy("test/auth/mocks/NonPayableWrappers.huff");
  }

  /// @notice Test that a non-matching signature reverts
  function testNonPayable(bytes32 callData) public {
    // Should revert for any call data where a value is sent
    vm.expectRevert();
    (bool fails,) = np.call{value: 1 ether}(abi.encode(callData));

    // Non value calls should succeed
    (bool success, bytes memory retBytes) = np.call(abi.encode(callData));
    assert(success);
    assertEq(bytes8(retBytes[31]), bytes8(hex"01"));
  }
}
