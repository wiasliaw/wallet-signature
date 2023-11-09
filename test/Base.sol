// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

// testing framework
import "forge-std/Test.sol";

// source
import {Wallet} from "../src/Wallet.sol";
import {CounterRaw} from "../src/CounterRaw.sol";

// common
import {Errors} from "../src/common/Errors.sol";

abstract contract BaseTest is Test {
    Account internal EOA;
    Account internal EOA2;
    Wallet internal wallet;

    CounterRaw internal raw;

    function setUp() external {
        EOA = makeAccount("EOA");
        EOA2 = makeAccount("EOA2");

        vm.startPrank(EOA.addr);
        wallet = new Wallet();
        raw = new CounterRaw(address(wallet));
        vm.stopPrank();
    }

    function _prepareDigest(
        uint256 value
    ) internal pure virtual returns (bytes32);
}
