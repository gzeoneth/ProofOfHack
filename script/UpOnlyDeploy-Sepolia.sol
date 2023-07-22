// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/UpOnly.sol";
import "../src/POHSafeModule.sol";

contract UpOnlyDeploySepolia is Script {
    function setUp() public {}

    function run() public {
        vm.createSelectFork(vm.rpcUrl("sepolia"));
        vm.startBroadcast();
        UpOnly uponly = new UpOnly(address(0));
        console.log(address(uponly));
        vm.stopBroadcast();
    }
}
