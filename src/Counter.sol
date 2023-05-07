// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "openzeppelin-contracts/contracts/access/Ownable.sol";
import "openzeppelin-contracts/contracts/utils/Address.sol";

import {IERC1271} from "./IERC1271.sol";

contract Counter is Ownable {
    using Address for address;

    uint256 public number;

    constructor(address _addr) {
        require(_addr.isContract(), "not a contract");
        _transferOwnership(_addr);
    }

    function setNumber(uint256 newNumber, bytes calldata signature) external {
        bytes32 hash = keccak256(abi.encode(newNumber));
        require(
            IERC1271(owner()).isValidSignature(hash, signature) ==
                IERC1271.isValidSignature.selector
        );
        number = newNumber;
    }
}
