//Splitter - Small Project 


pragma solidity ^0.4.18;

contract Splitter{
    
    //Owner of contract, sole ability to destroy/kill contract.
    address public owner;

    //Mapping each address to their balance. 
    mapping (address => uint) public balances; 

    //Events
    event LogSplitSent(address sender, address recipient1, address recipient2, uint totalamount);
    event LogSplitPulled(address recipient, uint split);

/* Constructor - run once when contract deployed. Not payable to avoid confusion
of sending ether during deployment.*/

function Splitter()
{
    //Save owner of contract as address who deployed to blockchain.
    owner = msg.sender;
}

//Modifiers
modifier notZero(uint value) {require(value >0); _;}
modifier onlyOwner {require(msg.sender == owner); _;}

/* Function in which sender can send money to contract to be split 
between two identified recipients. Method for odd values that do not 
split evenly, the contract favors recipient1. */
function deposit(address recipient1, address recipient2)
    notZero(msg.value)
    public
    payable
    returns(bool success)

{
        //Ensure Ethereum address used. Will also ensure this through Web3. 
        require(recipient1 != 0);
        require(recipient2 != 0);
        uint remainder = msg.value % 2;
        //Mapping balances, favoring first recipient. 
        balances[recipient1] += msg.value/2 + remainder; 
        balances[recipient2] += msg.value/2; 
        LogSplitSent(msg.sender, recipient1, recipient2, msg.value);
        return true;
}

/* Function to allow recipients to withdraw their funds from the contract. */
function withdraw()
    public 
    returns (bool success)
{
    require(balances[msg.sender] > 0);
    uint toSend = balances[msg.sender];
    balances[msg.sender] = 0;
    msg.sender.transfer(toSend);
    LogSplitPulled(msg.sender, toSend);
    return true; 
}


/* Self destructing kill switch, only works for contract creator. 
In this case, contract users must trust contract creator to control
kill switch. */

function stopIt()
    onlyOwner()
    public 
{
    selfdestruct(owner); //All funds in contract sent to owner. 
}

}

/* Idea for refactoring: Seperate out record keeping of balances in a different contract while retaining
Ether in this one. Create another contract that can be used as an address for self destruct to let those
who have balances remaining in this contract pull from it. */






