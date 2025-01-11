// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import "foundry-huff-neo/HuffNeoDeployer.sol";

interface EthersWrappers {
    function isPayable() external payable returns (uint256);
    function nonPayable() external returns (uint256);
}

contract EthersTest is Test {
    EthersWrappers ethers;

    function setUp() public {
        // Deploy Ethers Lib
        ethers = EthersWrappers(
            HuffNeoDeployer
                .config()
                .deploy("test/utils/mocks/EthersWrappers.huff")
        );
    }

    function testEthersPayable(uint256 amount) public {
        vm.assume(amount > 0);
        vm.deal(address(this), amount);
        uint256 balance_before = address(ethers).balance;
        uint256 result = ethers.isPayable{value: amount}();
        uint256 balance_after = address(ethers).balance;
        assert(balance_after > balance_before);
    }

    function testEthersNonPayable(uint256 amount) public {
        vm.assume(amount > 0);
        vm.expectRevert();
        (bool success, bytes memory res) = address(ethers).call{value: amount}(abi.encodeWithSignature("nonPayable()"));
        uint256 result = abi.decode(res, (uint256));
    }

    function testEthersNonPayable() public {
        uint256 balance_before = address(ethers).balance;
        uint256 result = ethers.nonPayable();
        uint256 balance_after = address(ethers).balance;
        assertEq(balance_before, balance_after);
        assertEq(balance_before, result);
    }
}