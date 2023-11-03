// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "openzeppelin-contracts/contracts/access/Ownable.sol";

import {IERC1271} from "./interface/IERC1271.sol";

/**
 * @title CounterEIP712
 * @dev A smart contract that enables secure updates of a number using the EIP-712 standard.
 * This contract is owned by an address with the authority to verify and set the number.
 */
contract CounterEIP712 is Ownable {
    // EIP-712 domain separator
    bytes32 private immutable DOMAIN_SEPARATOR;

    // The number, which can be changed using the setNumber function
    uint256 public number;

    // Type hash for the EIP-712 domain separator
    bytes32 private constant TYPE_HASH =
        keccak256(
            "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
        );

    // Type hash for the setNumber function
    bytes32 private constant SETNUMBER_TYPEHASH =
        keccak256("SetNumber(uint256 value)");

    /**
     * @dev Constructor to initialize the contract owner and set the EIP-712 domain separator.
     * @param _addr The address of a contract to be used as a domain separator.
     */
    constructor(address _addr) Ownable(_addr) {
        require(_addr.code.length > 0, "Not a contract");
        DOMAIN_SEPARATOR = keccak256(
            abi.encode(
                TYPE_HASH,
                keccak256(bytes("countereip712")),
                keccak256("\x01"), // Ethereum prefix for the message format
                block.chainid,
                address(this)
            )
        );
    }

    /**
     * @dev Compute the struct hash of a setNumber request to be used for signature verification.
     * @param value The new number to be set.
     * @return The hashed message that will be signed.
     */
    function setNumber_structHash(
        uint256 value
    ) internal pure returns (bytes32) {
        return keccak256(abi.encode(SETNUMBER_TYPEHASH, value));
    }

    /**
     * @dev Compute the EIP-712 digest for signature verification.
     * @param _number The new number data.
     * @return The EIP-712 digest for the given parameters.
     */
    function hashNewNumber(uint256 _number) public view returns (bytes32) {
        return
            keccak256(
                abi.encodePacked(
                    "\x19\x01", // Ethereum prefix for the message format
                    DOMAIN_SEPARATOR,
                    setNumber_structHash(_number)
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
                IERC1271.isValidSignature.selector,
            "Invalid signature"
        );
        number = _newNumber;
    }
}
