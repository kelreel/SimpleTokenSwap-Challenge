// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {Script, console} from "forge-std/Script.sol";
import {SimpleTokenSwapper} from "../Challenge/SimpleTokenSwapper-Challenge.sol";

contract Deploy is Script {
    function run() external returns (SimpleTokenSwapper) {
        vm.startBroadcast();

        SimpleTokenSwapper simpleTokenSwapper = new SimpleTokenSwapper();

        vm.stopBroadcast();
        return simpleTokenSwapper;
    }
}
