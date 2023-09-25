// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "openzeppelin-contracts/contracts/access/Ownable.sol";
import "openzeppelin-contracts/contracts/utils/cryptography/MessageHashUtils.sol";

import {IERC1271} from "./interface/IERC1271.sol";

contract CounterEIP191 is Ownable {
    uint256 public number;

    constructor(address _addr) Ownable(_addr) {
        require(_addr.code.length > 0, "not a contract");
    }

    function setNumber(uint256 newNumber, bytes calldata signature) external {
        bytes32 hash = MessageHashUtils.toEthSignedMessageHash(
            abi.encode(newNumber)
        );
        require(
            IERC1271(owner()).isValidSignature(hash, signature) ==
                IERC1271.isValidSignature.selector
        );
        number = newNumber;
    }
}
