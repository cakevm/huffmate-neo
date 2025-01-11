// SPDX-License-Identifier: BSD
pragma solidity ^0.8.15;

import {Test} from "forge-std/Test.sol";
import {HuffNeoDeployer} from "foundry-huff-neo/HuffNeoDeployer.sol";
import {IExampleClone, IExampleCloneFactory} from "./Interfaces.sol";

contract ExampleCloneTest is Test {
    IExampleClone internal clone;
    IExampleClone internal arrClone;
    IExampleCloneFactory internal factory;

    function setUp() public {
        IExampleClone impl = IExampleClone(HuffNeoDeployer.deploy("src/mechanisms/huff-clones/ExampleClone.huff"));
        factory = IExampleCloneFactory(HuffNeoDeployer.deploy_with_args("src/mechanisms/huff-clones/ExampleCloneFactory.huff", abi.encode(address(impl))));

        // Create (address, uint256, uint64, uint8) clone
        clone = IExampleClone(factory.createClone(address(this), type(uint256).max, 8008, 69));

        // Create (uint256[]) clone
        uint256[] memory a = new uint256[](5);
        for (uint i; i < 5; ++i) {
            a[i] = 256;
        }
        arrClone = IExampleClone(factory.createArrClone(a));
    }

    /// -----------------------------------------------------------------------
    /// Gas benchmarking
    /// -----------------------------------------------------------------------

    function testGas_param1() public view {
        clone.param1();
    }

    function testGas_param2() public view {
        clone.param2();
    }

    function testGas_param3() public view {
        clone.param3();
    }

    function testGas_param4() public view {
        clone.param4();
    }

    function testGas_param5() public view {
        arrClone.param5(5);
    }
}
