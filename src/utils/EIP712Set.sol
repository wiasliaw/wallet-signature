// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

bytes32 constant SET_TYPE_HASH = keccak256("Set(uint256 value)");

abstract contract EIP712Set {
    function _buildStructHash(uint256 value) internal pure returns (bytes32) {
        return keccak256(abi.encode(SET_TYPE_HASH, value));
    }

    function _buildSetDigest(
        bytes32 domain,
        uint256 value
    ) internal pure returns (bytes32) {
        bytes32 structHash = _buildStructHash(value);
        return keccak256(abi.encodePacked(hex"19_01", domain, structHash));
    }
}
