// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "@openzeppelin/contracts/token/ERC20/presets/ERC20PresetFixedSupply.sol";
import "../src/UpOnly.sol";

contract UpOnlyTest is Test {
    UpOnly public counter;

    address internal constant WHITEHAT = address(1337);

    function setUp() public {
        address token = address(new ERC20PresetFixedSupply("Bounty", "BNTY", 100 ether, address(this)));
        counter = new UpOnly(address(token));
        IERC20(token).transfer(address(counter), 10 ether);
    }

    function testIncrement() public {
        counter.increment(1);
        assertEq(counter.number(), 1);
    }

    function testProveOfHack() public {
        counter.increment(1);
        bytes memory payload = abi.encodeWithSignature("increment(uint256)", type(uint256).max - counter.number() + 1);
        vm.prank(WHITEHAT);
        counter.proofOfHack(address(counter), payload, false, "");
        assertTrue(counter.paused());
        assertEq(IERC20(counter.bountyToken()).balanceOf(WHITEHAT), 10 ether);
    }

    function testRevertNoHack() public {
        counter.increment(1);
        bytes memory payload = abi.encodeWithSignature("increment(uint256)", 1);
        vm.expectRevert("ProveOfHack: failed");
        counter.proofOfHack(address(counter), payload, false, "");
        assertFalse(counter.paused());
    }
}
