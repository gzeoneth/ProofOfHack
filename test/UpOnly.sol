// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/UpOnly.sol";

contract UpOnlyTest is Test {
    UpOnly public counter;

    function setUp() public {
        counter = new UpOnly();
    }

    function testIncrement() public {
        counter.increment(1);
        assertEq(counter.number(), 1);
    }

    function testProveOfHack() public {
        counter.increment(1);
        bytes memory payload = abi.encodeWithSignature("increment(uint256)", type(uint256).max - counter.number() + 1);
        counter.proofOfHack(address(counter), payload);
        assertTrue(counter.paused());
    }

    function testRevertNoHack() public {
        counter.increment(1);
        bytes memory payload = abi.encodeWithSignature("increment(uint256)", 1);
        vm.expectRevert("ProveOfHack: failed");
        counter.proofOfHack(address(counter), payload);
        assertFalse(counter.paused());
    }
}
