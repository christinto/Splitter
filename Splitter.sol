//Splitter - Small Project 
//3 people - Alice, Bob & Carol 
//Balance can be seen on splitter contract webpage
//Whenever Alice sends ether, half go to Bob and half goes to Carol
//Can see the balances of Alice, Bob & Carol on the webpage
//Ether can be send to the contract from the webpage

pragma solidity ^0.4.6;

contract Splitter{
    address public owner; //Alice
    mapping (address => uint) public balances; //Mapping each address to their balance

// Struct to show address and balances together.
struct ShowBalances{
    address someOne;
    uint    money;
}

ShowBalances[] public showBalances; 

//Constructor - run once when contract deployed 
function Splitter()
{
    //Identifying owner
    owner = msg.sender;        
 }

//Takes in the amount to send to Bob & Carol
function toPut()
    public
    payable
    returns(bool success)
    {
        //Cases to stop early (throw)
        if (msg.sender != owner) throw; //if function not sent by owner
        if (msg.value < 0) throw; 
        return true;
    }

//Sending funds to Bob or Carol
function toSend(address toPerson)
    public
    returns (bool success)
    //Assuming no need to make this payable as funds paid through toSend()
    {
    //Cases to throw
    if (msg.sender != owner) throw;
    if (this.balance <= 0) throw; 
    //Send money
    toPerson.transfer(this.balance/2);
    return true;
    }

//How to show balances for the website? Will wait for feedback.
        
        // //Showing new balances - mapping
        // balances[recipientOne] = recipientOne.balance;
        // balances[recipientTwo] = recipientTwo.balance;
        // balances[owner] = owner.balance; 
        // balances[splitAd] = this.balance; 
        
        // //Showing new balances - 
        // ShowBalances memory newBalance0;
        // newBalance0.someOne = this; 
        // newBalance0.money = this.balance;
        // showBalances.push(newBalance0);
        // ShowBalances memory newBalance1;
        // newBalance1.someOne = msg.sender; 
        // newBalance1.money = owner.balance; 
        // showBalances.push(newBalance1);
        // ShowBalances memory newBalance2;
        // newBalance2.someOne = recipientOne; 
        // newBalance2.money += recipientOne.balance; 
        // showBalances.push(newBalance2);
        // ShowBalances memory newBalance3;
        // newBalance3.someOne = recipientTwo; 
        // newBalance3.money += recipientTwo.balance;
        // showBalances.push(newBalance3);
       
//Self destructing kill switch, only works for contract creator
// Are you able to test selfdestruct() in browser solidity? 
function stopIt()
    public 
    returns (bool success)
    {
    if (msg.sender != owner) throw; //extra check, just in case
    selfdestruct(owner); //send all funds back to owner
    return true;
    }
}
        
    
  
