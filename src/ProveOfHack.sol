// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./HackExecutor.sol";

contract ProveOfHack {
    HackExecutor private immutable executor;

    constructor() {
        executor = new HackExecutor();
    }

    function _preHackSnapshot() internal virtual {}

    function _postHackCheck() internal virtual returns (bool) {
        return false;
    }

    function _postHackAction() internal virtual {}

    function _proofOfHack(address to, bytes calldata payload) external {
        _preHackSnapshot();
        executor.execute(to, payload);
        require(_postHackCheck(), "ProveOfHack: failed");
        revert("ProveOfHack: pwned");
    }

    function proofOfHack(address to, bytes calldata payload) external {
        try this._proofOfHack(to, payload) {
            revert("ProveOfHack: unreachable");
        } catch {
            string memory a;
            assembly {
                a := mload(0x40)
            }
            if (keccak256(abi.encodePacked(a)) != keccak256(abi.encodePacked("ProveOfHack: pwned"))) {
                revert("ProveOfHack: failed");
            }
            _postHackAction();
        }
    }
}
