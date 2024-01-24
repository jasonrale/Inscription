// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/proxy/Clones.sol";

import "./Template.sol";

contract Inscriber {
    address immutable template;
    
    mapping(address tokenAddr => uint256) public totalSupplys;

    constructor(address _template) {
        template = _template;
    }

    function deployInscription(string calldata name, string calldata symbol, uint256 totalSupply, uint256 perMint) external returns(address inscription) {
        address tokenAddr = Clones.clone(template);
        Template(tokenAddr).init(name, symbol, perMint);
        totalSupplys[tokenAddr] = totalSupply;
        return tokenAddr;
    }

    function mintInscription(address tokenAddr) external {
        require(Template(tokenAddr).totalSupply() < totalSupplys[tokenAddr], "Minted out");
        Template(tokenAddr).mint(msg.sender);
    }
}