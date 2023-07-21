// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Counter.sol";

contract CounterTest is Test {
    Counter public counter;

    function setUp() public {
        counter = new Counter();
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
}
