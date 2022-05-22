//Smart Contract for a Decentralized Lottery Application

//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.6.0 <0.9.0;

contract LotteryContract {
    address public manager;
    address payable[] public participants;
    
    constructor(){
        manager=msg.sender;
    }
    
    receive() external payable
    {
        require(msg.value == 1 ether);
        participants.push(payable(msg.sender));

    }
    // Finding the amount of ether in this contract
    function contractBalance() public view returns(uint)
    {
        require(msg.sender == manager);
        return address(this).balance;
    }
    // generating a random value
    function randomValue() public view returns(uint)
    {
        return uint(keccak256(abi.encode(block.difficulty,block.timestamp,participants.length,block.number)));
    }
    // Winner selection procedure
    function selectWinner () public{
        require (msg.sender== manager);
        require(participants.length >=5);
        uint randomno = randomValue();
        uint index = randomno % (participants.length + 1);
        address payable winner = participants[index];
        winner.transfer(contractBalance());
        participants = new address payable [](0);
    }  
}
