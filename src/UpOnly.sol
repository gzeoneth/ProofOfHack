// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/security/Pausable.sol";
import "./ProveOfHack.sol";

contract UpOnly is Pausable, ProveOfHack {
    uint256 public number;

    uint256 private snapshot;

    function _preHackSnapshot() internal override {
        // this will be called before invoking ProveOfHack
        // we store the current state of the contract in a snapshot variable
        snapshot = number;
    }

    constructor(address _bountyToken) Pausable() ProveOfHack(_bountyToken) {}

    function _postHackCheck() internal view override returns (bool) {
        // this will be called after invoking ProveOfHack to check if there is a hack
        // we define the hack as the number decremented in this example
        return number < snapshot;
    }

    function _postHackAction() internal override {
        // this will be called when ProveOfHack identified a hack
        // we pause the contract in this example
        _pause();
    }

    function increment(uint256 x) public {
        unchecked {
            number += x;
        }
    }
}
