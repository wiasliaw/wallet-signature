// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "openzeppelin-contracts/contracts/utils/cryptography/MessageHashUtils.sol";

import "../Base.sol";

contract TestCounterEIP191 is BaseTest {
    function testSet(uint256 expectResult) external {
        // calc digest
        bytes32 digest = _prepareDigest(expectResult);

        // sign
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(EOA.key, digest);

        // test
        eip191.set(expectResult, bytes.concat(r, s, bytes1(v)));
        assertEq(eip191.get(), expectResult);
    }

    function _prepareDigest(
        uint256 value
    ) internal pure override returns (bytes32) {
        return MessageHashUtils.toEthSignedMessageHash(abi.encode(value));
    }
}
