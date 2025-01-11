// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import "foundry-huff-neo/HuffNeoDeployer.sol";

interface ICalls {
    function callFunc() external;
    function staticcallFunc() external;
    function callcodeFunc() external;
}

contract CallsTest is Test {
    ICalls calls;

    function setUp() public {
        calls = ICalls(HuffNeoDeployer.deploy("test/utils/mocks/CallWrappers.huff"));
    }

    function testCall() public {
        calls.callFunc();
    }

    function testStaticCall() public {
        calls.staticcallFunc();
    }

    function testCallCode() public {
        calls.callcodeFunc();
    }
}