// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./ProveOfHack.sol";
import "./UpOnly.sol";
import "./interfaces/IGnosisSafe.sol";

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
