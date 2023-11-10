// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "openzeppelin-contracts/contracts/access/Ownable.sol";

import {IERC1271} from "./interface/IERC1271.sol";
import {ICounter} from "./interface/ICounter.sol";
import {Errors} from "./common/Errors.sol";
import {EIP712Domain} from "./utils/EIP712Domain.sol";
import {EIP712Set} from "./utils/EIP712Set.sol";

/**
 * @title CounterEIP712
 * @dev A smart contract that enables secure updates of a number using the EIP-712 standard.
 * This contract is owned by an address with the authority to verify and set the number.
 */
contract CounterEIP712 is ICounter, Ownable, EIP712Domain, EIP712Set {
    // The number, which can be changed using the setNumber function
    uint256 internal number;

    // EIP712 Domain
    bytes32 public immutable DOMAIN;

    /**
     * @dev Constructor to initialize the contract owner and set the EIP-712 domain separator.
     * @param _addr The address of a contract to be used as a domain separator.
     */
    constructor(address _addr) Ownable(_addr) EIP712Domain("Counter", "1") {
        if (_addr.code.length == 0) revert Errors.NotContract(_addr);
        DOMAIN = _buildDomainSeparator();
    }

    /**
     * @dev Update the number using EIP-712 signature verification.
     * @param _newNumber The new number to be set.
     * @param signature The EIP-712 signature to verify the transaction.
     */
    function set(uint256 _newNumber, bytes calldata signature) external {
        bytes32 hash = _buildSetDigest(DOMAIN, _newNumber);
        if (
            IERC1271(owner()).isValidSignature(hash, signature) !=
            IERC1271.isValidSignature.selector
        ) revert Errors.InvalidSignature();
        number = _newNumber;
    }

    function get() external view returns (uint256) {
        return number;
    }
}
