// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "../Base.sol";

contract TestCounter is BaseTest {
    function testSet(uint256 expectResult) external {
        // calc digest
        bytes32 digest = _prepareDigest(expectResult);

        // sign
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(EOA.key, digest);

        // test
        raw.set(expectResult, bytes.concat(r, s, bytes1(v)));
        assertEq(raw.get(), expectResult);
    }

    function testSetFail(uint256 expectResult) external {
        // calc digest
        bytes32 digest = _prepareDigest(expectResult);

        // sign
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(EOA2.key, digest);

        // test
        vm.expectRevert(Errors.InvalidSignature.selector);
        raw.set(expectResult, bytes.concat(r, s, bytes1(v)));
    }

    function _prepareDigest(
        uint256 value
    ) internal pure override returns (bytes32) {
        return keccak256(abi.encode(value));
    }
}
