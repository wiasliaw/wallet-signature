// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "openzeppelin-contracts/contracts/access/Ownable.sol";
import "openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol";

/**
 * @title TransferEIP712
 * @dev A smart contract that allows secure token transfers using the EIP-712 standard.
 * The contract is owned by an address that has the authority to mint tokens.
 */
contract TransferEIP712 is Ownable {
    using ECDSA for bytes32; // Utilize ECDSA for signature recovery

    // EIP-712 domain separator
    bytes32 private DOMAIN_SEPARATOR;

    // Mapping of account balances
    mapping(address => uint256) public balance;

    // Data struct for transfer request
    struct TransferRequest {
        address from;
        address to;
        uint256 amount;
    }

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
                keccak256(bytes("eip712transfer")),
                keccak256("\x01"), // Ethereum prefix for message format
                block.chainid,
                address(this)
            )
        );
    }

    /**
     * @dev Hash a transfer request to be used for signature verification.
     * @param _transfer The transfer request data.
     * @return The hashed message that will be signed.
     */
    function hashTransferRequest(
        TransferRequest memory _transfer
    ) internal view returns (bytes32) {
        return
            keccak256(
                abi.encodePacked(
                    "\x19\x01", // Ethereum prefix for message format
                    DOMAIN_SEPARATOR,
                    keccak256(
                        abi.encode(
                            _transfer.from,
                            _transfer.to,
                            _transfer.amount
                        )
                    )
                )
            );
    }

    /**
     * @dev Verify the signature of a transfer request.
     * @param signer The expected signer of the message.
     * @param transferRequestHash The hashed transfer request.
     * @param signature The signature to verify.
     * @return True if the signature is valid; otherwise, false.
     */
    function verifySignature(
        address signer,
        bytes32 transferRequestHash,
        bytes calldata signature
    ) internal pure returns (bool) {
        return signer == transferRequestHash.recover(signature);
    }

    /**
     * @dev Transfer tokens from one address to another using EIP-712 signature verification.
     * @param from The sender's address.
     * @param to The recipient's address.
     * @param amount The amount of tokens to transfer.
     * @param signature The EIP-712 signature to verify the transaction.
     */
    function transfer(
        address from,
        address to,
        uint256 amount,
        bytes calldata signature
    ) external {
        require(from == msg.sender, "Address not allowed to transfer");
        TransferRequest memory transferrequest = TransferRequest(
            from,
            to,
            amount
        );
        bytes32 dataHash = hashTransferRequest(transferrequest);
        require(
            verifySignature(from, dataHash, signature),
            "Invalid signature"
        );
        balance[from] -= amount;
        balance[to] += amount;
    }
}
