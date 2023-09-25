// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "openzeppelin-contracts/contracts/access/Ownable.sol";
import "openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol";

import {IERC1271} from "./interface/IERC1271.sol";

contract Wallet is IERC1271, Ownable {
    constructor() Ownable(msg.sender) {}

    function isValidSignature(
        bytes32 _hash,
        bytes calldata _signature
    ) external view returns (bytes4 magic) {
        require(ECDSA.recover(_hash, _signature) == owner(), "invalid signer");
        magic = IERC1271.isValidSignature.selector;
    }
}
