// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./HackExecutor.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract ProveOfHack {
    HackExecutor public immutable executor;
    IERC20 public immutable bountyToken;

    constructor(address _bountyToken) {
        executor = new HackExecutor();
        bountyToken = IERC20(_bountyToken);
    }

    function _preHackSnapshot() internal virtual {}

    function _postHackCheck() internal virtual returns (bool) {
        return false;
    }

    function _postHackAction() internal virtual {}

    function _payoutBounty(address to) internal virtual {
        bountyToken.transfer(to, bountyToken.balanceOf(address(this)));
    }

    function _proofOfHack(address to, bytes calldata payload, bool isDelegateCall) external {
        _preHackSnapshot();
        executor.execute(to, payload, isDelegateCall);
        require(_postHackCheck(), "ProveOfHack: failed");
        revert("ProveOfHack: pwned");
    }

    function proofOfHack(address to, bytes calldata payload, bool isDelegateCall) external {
        try this._proofOfHack(to, payload, isDelegateCall) {
            revert("ProveOfHack: unreachable");
        } catch Error(string memory reason) {
            if (keccak256(abi.encodePacked(string(reason))) != keccak256(abi.encodePacked("ProveOfHack: pwned"))) {
                revert(reason);
            }
            _postHackAction();
            _payoutBounty(msg.sender);
        }
    }
}
