// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

abstract contract OpEnum {
    enum Operation {
        Call,
        DelegateCall
    }
}

interface IGnosisSafe {
    function execTransactionFromModule(address to, uint256 value, bytes memory data, OpEnum.Operation operation)
        external
        returns (bool success);
}
