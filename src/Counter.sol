// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "openzeppelin-contracts/contracts/access/Ownable.sol";

import {IERC1271} from "./interface/IERC1271.sol";

contract Counter is Ownable {
    uint256 public number;

    constructor(address _addr) Ownable(_addr) {
        require(_addr.code.length > 0, "not a contract");
    }

    /// @notice only sign the number which will be set
    function setNumber(uint256 newNumber, bytes calldata signature) external {
        bytes32 hash = keccak256(abi.encode(newNumber));
        require(
            IERC1271(owner()).isValidSignature(hash, signature) ==
                IERC1271.isValidSignature.selector
        );
        number = newNumber;
    }
}
