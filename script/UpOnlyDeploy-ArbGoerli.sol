// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/UpOnly.sol";
import "../src/POHSafeModule.sol";

contract UpOnlyDeployArbGoerli is Script {
    function setUp() public {}

    function run() public {
        vm.createSelectFork(vm.rpcUrl("arbgoerli"));
        vm.startBroadcast();
        address safe = 0xe9B795BFc37fc3c9D79b468C3306DAa4E8382a6B; // redeployed 1-1 safe
        UpOnly uponly = new UpOnly(address(0));
        console.log(address(uponly));
        POHSafeModule safemodule = new POHSafeModule(address(safe), address(uponly), address(0));
        console.log(address(safemodule));
        uponly.transferOwnership(safe);
        vm.stopBroadcast();
    }
}
