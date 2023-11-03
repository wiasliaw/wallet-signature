// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "forge-std/Test.sol";
import "openzeppelin-contracts/contracts/utils/cryptography/MessageHashUtils.sol";

import {CounterEIP712} from "../src/CounterEIP712.sol";
import {Wallet} from "../src/Wallet.sol";

contract TestCounterEIP712 is Test {
    address private eoa;
    uint256 private privkey;

    Wallet private w;
    CounterEIP712 private c;

    function setUp() external {
        (eoa, privkey) = makeAddrAndKey("EOA");
        vm.deal(eoa, 100 ether);

        vm.startPrank(eoa);
        w = new Wallet();
        c = new CounterEIP712(address(w));
        vm.stopPrank();
    }

    function testSetNumber(uint256 expectResult) external {
        bytes32 hash = c.hashNewNumber(expectResult);
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(privkey, hash);

        vm.startPrank(eoa);
        c.setNumber(expectResult, bytes.concat(r, s, bytes1(v)));
        vm.stopPrank();
        assertEq(c.number(), expectResult);
    }
}
