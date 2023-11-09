// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

// testing framework
import "forge-std/Test.sol";

// source
import {Wallet} from "../src/Wallet.sol";
import {CounterRaw} from "../src/CounterRaw.sol";
import {CounterEIP191} from "../src/CounterEIP191.sol";

// common
import {Errors} from "../src/common/Errors.sol";

abstract contract BaseTest is Test {
    Account internal EOA;
    Account internal EOA2;
    Wallet internal wallet;

    CounterRaw internal raw;
    CounterEIP191 internal eip191;

    function setUp() external {
        EOA = makeAccount("EOA");
        EOA2 = makeAccount("EOA2");

        vm.startPrank(EOA.addr);
        wallet = new Wallet();
        raw = new CounterRaw(address(wallet));
        eip191 = new CounterEIP191(address(wallet));
        vm.stopPrank();
    }

    function _prepareDigest(
        uint256 value
    ) internal pure virtual returns (bytes32);
}
