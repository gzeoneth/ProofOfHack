// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract HackExecutor {
    function execute(address to, bytes calldata payload, bool isDelegateCall) external {
        bool success;
        if (isDelegateCall) {
            (success,) = to.delegatecall(payload);
        } else {
            (success,) = to.call(payload);
        }
        require(success, "HackExecutor: execute failed");
    }
}
