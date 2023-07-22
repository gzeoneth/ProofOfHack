// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./ProveOfHack.sol";
import "./UpOnly.sol";
import {BasePluginWithEventMetadata, PluginMetadata} from "./safecore/Base.sol";
import {ISafe} from "@safe-global/safe-core-protocol/contracts/interfaces/Accounts.sol";
import {ISafeProtocolManager} from "@safe-global/safe-core-protocol/contracts/interfaces/Manager.sol";
import {SafeTransaction, SafeProtocolAction} from "@safe-global/safe-core-protocol/contracts/DataTypes.sol";

contract POHSafePlugin is BasePluginWithEventMetadata, ProveOfHack {
    ISafeProtocolManager public immutable manager;
    ISafe public immutable safe;
    UpOnly public immutable uponly;

    uint256 private _snapshot;

    constructor(address _manager, address _safe, address _uponly, address _bountyToken)
        ProveOfHack(_bountyToken)
        BasePluginWithEventMetadata(
            PluginMetadata({
                name: "ProveOfHack for UpOnly Plugin",
                version: "1.0.0",
                requiresRootAccess: false,
                iconUrl: "",
                appUrl: "https://github.com/gzeoneth/ProofOfHack"
            })
        )
    {
        manager = ISafeProtocolManager(_manager);
        safe = ISafe(_safe);
        uponly = UpOnly(_uponly);
    }

    function _preHackSnapshot() internal override {
        _snapshot = uponly.number();
    }

    function _postHackCheck() internal view override returns (bool) {
        return uponly.number() < _snapshot;
    }

    function _postHackAction() internal override {
        SafeProtocolAction[] memory actions = new SafeProtocolAction[](1);
        actions[0].to = payable(address(uponly));
        actions[0].value = 0;
        actions[0].data = abi.encodeWithSelector(UpOnly.pause.selector);
        uint256 nonce = uint256(keccak256(abi.encode(this, manager, safe, actions[0].data)));
        SafeTransaction memory safeTx = SafeTransaction({actions: actions, nonce: nonce, metadataHash: bytes32(0)});
        manager.executeTransaction(safe, safeTx);
    }
}
