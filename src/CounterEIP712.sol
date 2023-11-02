// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "openzeppelin-contracts/contracts/access/Ownable.sol";

import {IERC1271} from "./interface/IERC1271.sol";

/**
 * @title CounterEIP712
 * @dev A smart contract that allows secure updates of a number using the EIP-712 standard.
 * The contract is owned by an address that has the authority to verify and set the number.
 */
contract CounterEIP712 is Ownable {
    // EIP-712 domain separator
    bytes32 private DOMAIN_SEPARATOR;

    // Number, which can get changed with setNumber
    uint256 public number;

    /**
     * @dev Constructor to initialize the contract owner and set the EIP-712 domain separator.
     * @param _addr The address of a contract to be used as a domain separator.
     */
    constructor(address _addr) Ownable(_addr) {
        require(_addr.code.length > 0, "Not a contract");
        DOMAIN_SEPARATOR = keccak256(
            abi.encode(
                keccak256(
                    "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
                ),
                keccak256(bytes("countereip712")),
                keccak256("\x01"), // Ethereum prefix for message format
                block.chainid,
                address(this)
            )
        );
    }

    /**
     * @dev Hash a new number to be used for signature verification.
     * @param _number The new number data.
     * @return The hashed message that will be signed.
     */
    function hashNewNumber(uint256 _number) public view returns (bytes32) {
        return
            keccak256(
                abi.encodePacked(
                    "\x19\x01", // Ethereum prefix for message format
                    DOMAIN_SEPARATOR,
                    keccak256(abi.encode(_number))
                )
            );
    }

    /**
     * @dev Update the number using EIP-712 signature verification.
     * @param _newNumber The new number to be set.
     * @param signature The EIP-712 signature to verify the transaction.
     */
    function setNumber(uint256 _newNumber, bytes calldata signature) external {
        bytes32 dataHash = hashNewNumber(_newNumber);
        require(
            IERC1271(owner()).isValidSignature(dataHash, signature) ==
                IERC1271.isValidSignature.selector
        );
        number = _newNumber;
    }
}
