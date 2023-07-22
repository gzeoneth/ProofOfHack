// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/UpOnly.sol";

contract UpOnlyDeployNeonDevnet is Script {
    function setUp() public {}

    function run() public {
        vm.createSelectFork(vm.rpcUrl("neondevnet"));
        vm.startBroadcast();
        UpOnly uponly = new UpOnly(0x512E48836Cd42F3eB6f50CEd9ffD81E0a7F15103); // usdc on neon
        console.log(address(uponly));
        vm.stopBroadcast();
    }
}
