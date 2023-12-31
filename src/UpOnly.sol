// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./ProveOfHack.sol";

contract UpOnly is Ownable, Pausable, ProveOfHack {
    uint256 public number;

    uint256 private _snapshot;

    constructor(address _bountyToken) Ownable() Pausable() ProveOfHack(_bountyToken) {}

    function _preHackSnapshot() internal override {
        // this will be called before invoking ProveOfHack
        // we store the current state of the contract in a snapshot variable
        _snapshot = number;
    }

    function _postHackCheck() internal view override returns (bool) {
        // this will be called after invoking ProveOfHack to check if there is a hack
        // we define the hack as the number decremented in this example
        return number < _snapshot;
    }

    function _postHackAction() internal override {
        // this will be called when ProveOfHack identified a hack
        // we pause the contract in this example
        _pause();
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function increment(uint256 x) public {
        unchecked {
            number += x;
        }
    }
}
