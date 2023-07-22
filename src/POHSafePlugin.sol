// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./ProveOfHack.sol";
import "./UpOnly.sol";
import {BasePluginWithEventMetadata, PluginMetadata} from "./safecore/Base.sol";
import {ISafe} from "@safe-global/safe-core-protocol/contracts/interfaces/Accounts.sol";
import {ISafeProtocolManager} from "@safe-global/safe-core-protocol/contracts/interfaces/Manager.sol";
import {SafeTransaction, SafeProtocolAction} from "@safe-global/safe-core-protocol/contracts/DataTypes.sol";
import {_getFeeCollectorRelayContext, _getFeeTokenRelayContext, _getFeeRelayContext} from "@gelatonetwork/relay-context/contracts/GelatoRelayContext.sol";

contract POHSafeModule is ProveOfHack {
    IGnosisSafe public immutable safe;
    UpOnly public immutable uponly;

    uint256 private _snapshot;

    constructor(address _safe, address _uponly, address _bountyToken) ProveOfHack(_bountyToken) {
        safe = IGnosisSafe(_safe);
        uponly = UpOnly(_uponly);
    }

    function _preHackSnapshot() internal override {
        _snapshot = uponly.number();
    }

    function _postHackCheck() internal view override returns (bool) {
        return uponly.number() < _snapshot;
    }

    function _postHackAction() internal override {
        safe.execTransactionFromModule(address(uponly), 0, abi.encodeCall(UpOnly.pause, ()), OpEnum.Operation.Call);
    }
}
