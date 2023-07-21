// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "./ProveOfHack.sol";

contract Counter is PausableUpgradeable, ProveOfHack {
    uint256 public number;

    uint256 private snapshot;

    function _preHackSnapshot() internal override {
        snapshot = number;
    }

    function _postHackCheck() internal view override returns (bool) {
        return number < snapshot;
    }

    function _postHackAction() internal override {
        _pause();
    }

    function increment(uint256 x) public {
        unchecked {
            number += x;
        }
    }
}
