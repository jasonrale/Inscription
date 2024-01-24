// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";

import "../src/Inscriber.sol";
import "../src/Template.sol";

contract InscriberScript is Script {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        new Inscriber(address(new Template()));
        vm.stopBroadcast();
    }
}