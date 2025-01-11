// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import { Test } from "forge-std/Test.sol";
import { console2 } from "forge-std/console2.sol";
import { HuffNeoDeployer } from "foundry-huff-neo/HuffNeoDeployer.sol";

interface IShuffler {
    function oneWayShuffle(bytes32 seed, uint256 index, uint256 count, uint256 rounds) external view returns (uint256);
}

contract ShufflingTest is Test {
    IShuffler shuffler;

    function setUp() public {
        shuffler = IShuffler(HuffNeoDeployer.deploy("test/utils/mocks/ShufflingWrappers.huff"));
    }

    function testShuffle() public {
        bytes32 seed = bytes32(abi.encode("RANDOM_SEED"));
        uint256 index = 1337;
        uint256 count = 10;
        uint256 rounds = 10;
        uint256 shuffled_index = shuffler.oneWayShuffle(seed, index, count, rounds);
        console2.log(shuffled_index);
    }

}