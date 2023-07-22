// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./ProveOfHack.sol";
import "./UpOnly.sol";
import "./interfaces/IZkBobDirectDeposits.sol";

contract UpOnlyZkBob is UpOnly {
    IZkBobDirectDeposits public immutable queue;

    // Seploia BOB 0x2c74b18e2f84b78ac67428d0c7a9898515f0c46f
    // Seploia ZkBobDirectDepositsQueue 0xE3Dd183ffa70BcFC442A0B9991E682cA8A442Ade
    constructor(address _bountyToken, address _queue) UpOnly(_bountyToken) {
        queue = IZkBobDirectDeposits(_queue);
    }

    function _payoutBounty(address to, bytes calldata payoutData) internal override {
        if (payoutData.length == 0) {
            bountyToken.transfer(to, bountyToken.balanceOf(address(this)));
        } else {
            bytes memory zkAddress = abi.decode(payoutData, (bytes));
            address fallbackReceiver = to;

            uint256 balance = bountyToken.balanceOf(address(this));
            bountyToken.approve(address(queue), balance);
            uint256 depositId = queue.directDeposit(fallbackReceiver, balance, zkAddress);
        }
    }
}
