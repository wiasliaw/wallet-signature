// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

interface ICounter {
    function get() external view returns (uint256);

    function set(uint256, bytes calldata) external;
}
