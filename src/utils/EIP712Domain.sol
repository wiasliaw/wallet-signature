// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

bytes32 constant DOMAIN_TYPE_HASH = keccak256(
    "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
);

abstract contract EIP712Domain {
    bytes32 internal immutable _hashName;
    bytes32 internal immutable _hashVersion;

    constructor(string memory name, string memory version) {
        _hashName = keccak256(abi.encodePacked(name));
        _hashVersion = keccak256(abi.encodePacked(version));
    }

    function _buildDomainSeparator() internal view returns (bytes32) {
        return
            keccak256(
                abi.encode(
                    DOMAIN_TYPE_HASH,
                    _hashName,
                    _hashVersion,
                    block.chainid,
                    address(this)
                )
            );
    }
}
