// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "forge-std/Test.sol";
import "openzeppelin-contracts/contracts/utils/cryptography/MessageHashUtils.sol";

import {CounterEIP191} from "../src/CounterEIP191.sol";
import {Wallet} from "../src/Wallet.sol";

contract TestCounterEIP191 is Test {
    address private eoa;
    uint256 private privkey;

    Wallet private w;
    CounterEIP191 private c;

    function setUp() external {
        (eoa, privkey) = makeAddrAndKey("EOA");
        vm.deal(eoa, 100 ether);

        vm.startPrank(eoa);
        w = new Wallet();
        c = new CounterEIP191(address(w));
        vm.stopPrank();
    }

    function testSetNumber(uint256 expectResult) external {
        bytes32 hash = MessageHashUtils.toEthSignedMessageHash(
            abi.encode(expectResult)
        );
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(privkey, hash);

        vm.startPrank(eoa);
        c.setNumber(expectResult, bytes.concat(r, s, bytes1(v)));
        vm.stopPrank();
        assertEq(c.number(), expectResult);
    }
}
