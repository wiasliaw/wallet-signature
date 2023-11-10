// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "openzeppelin-contracts/contracts/utils/cryptography/MessageHashUtils.sol";
import "../Base.sol";
import {EIP712Set} from "../../src/utils/EIP712Set.sol";

contract TestCounterEIP712 is BaseTest, EIP712Set {
    function testSet(uint256 expectResult) external {
        bytes32 hash = _prepareDigest(expectResult);
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(EOA.key, hash);
        eip712.set(expectResult, bytes.concat(r, s, bytes1(v)));
        assertEq(eip712.get(), expectResult);
    }

    function _prepareDigest(
        uint256 value
    ) internal view override returns (bytes32) {
        return
            MessageHashUtils.toTypedDataHash(
                eip712.DOMAIN(),
                _buildStructHash(value)
            );
    }
}
