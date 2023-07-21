// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract HackExecutor {
    function execute(address to, bytes calldata payload) external {
        (bool success,) = to.call(payload);
        require(success, "HackExecutor: execute failed");
    }
}
