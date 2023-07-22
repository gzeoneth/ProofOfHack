// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/UpOnly.sol";
import "../src/POHSafePlugin.sol";

contract UpOnlyDeployGoerli is Script {
    function setUp() public {}

    function run() public {
        vm.createSelectFork(vm.rpcUrl("goerli"));
        vm.startBroadcast();
        address manager = 0xAbd9769A78Ee63632A4fb603D85F63b8D3596DF9;
        address safe = 0x605Db92bb118e9C967CC41cF504F091591DbaaaA; // predeployed 1-1 safe
        UpOnly uponly = new UpOnly(address(0));
        console.log(address(uponly));
        POHSafePlugin safeplugin = new POHSafePlugin(address(manager), address(safe), address(uponly), address(0));
        console.log(address(safeplugin));
        uponly.transferOwnership(safe);
        vm.stopBroadcast();
    }
}
