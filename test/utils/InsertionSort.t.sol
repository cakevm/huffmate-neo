// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "foundry-huff-neo/HuffNeoDeployer.sol";
import "forge-std/Test.sol";

contract InsertionSortTest is Test {
    /// @dev Address of the InsertionSort contract.
    InsertionSort public insertionSortContract;

    /// @dev Setup the testing environment.
    function setUp() public {
        insertionSortContract = InsertionSort(
            HuffNeoDeployer.deploy("test/utils/mocks/InsertionSortWrappers.huff")
        );
    }

    /// @dev Ensure that it returns passed arr.
    function testInsertionSort() public {
        uint256[] memory arr = new uint256[](6);
        arr[0] = 77;
        arr[1] = 4;
        arr[2] = 15;
        arr[3] = 6;
        arr[4] = 100;
        arr[5] = 8;

        uint256[] memory newArr = insertionSortContract.insertionSort(arr);

        assertEq(newArr[0], 4);
        assertEq(newArr[1], 6);
        assertEq(newArr[2], 8);
        assertEq(newArr[3], 15);
        assertEq(newArr[4], 77);
        assertEq(newArr[5], 100);
    }
}

interface InsertionSort {
    function insertionSort(uint256[] memory)
        external
        returns (uint256[] memory);
}
