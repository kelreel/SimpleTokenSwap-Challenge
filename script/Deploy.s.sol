// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {Script, console} from "forge-std/Script.sol";
import {SimpleTokenSwapper} from "../Challenge/SimpleTokenSwapper-Challenge.sol";
import "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";

contract Deploy is Script {
    function run() external returns (SimpleTokenSwapper) {
        vm.startBroadcast();

        SimpleTokenSwapper simpleTokenSwapper = new SimpleTokenSwapper(
            ISwapRouter(0xfc30937f5cDe93Df8d48aCAF7e6f5D8D8A31F636),
            0x5300000000000000000000000000000000000004
        );

        vm.stopBroadcast();
        return simpleTokenSwapper;
    }
}
