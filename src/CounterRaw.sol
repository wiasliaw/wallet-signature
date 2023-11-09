// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "openzeppelin-contracts/contracts/access/Ownable.sol";

import {IERC1271} from "./interface/IERC1271.sol";
import {ICounter} from "./interface/ICounter.sol";
import {Errors} from "./common/Errors.sol";

contract CounterRaw is ICounter, Ownable {
    uint256 internal number;

    constructor(address _addr) Ownable(_addr) {
        require(_addr.code.length > 0, "not a contract");
    }

    function set(uint256 newNumber, bytes calldata signature) external {
        bytes32 hash = keccak256(abi.encode(newNumber));
        if (
            IERC1271(owner()).isValidSignature(hash, signature) !=
            IERC1271.isValidSignature.selector
        ) revert Errors.InvalidSignature();
        number = newNumber;
    }

    function get() external view returns (uint256) {
        return number;
    }
}
