//Splitter - Small Project 
//3 people - Alice, Bob & Carol 
//Balance can be seen on splitter contract webpage
//Whenever Alice sends ether, half go to Bob and half goes to Carol
//Can see the balances of Alice, Bob & Carol on the webpage
//Ether can be send to the contract from the webpage

pragma solidity ^0.4.6;

contract Splitter{
    address public owner; //Alice
    address public recipientOne; //Carol
    address public recipientTwo; //Bob
    address public splitAd; //contract address
    uint    public _amount; //total amount to send
    uint    public newAmount; //To send to Carol or Bob
    mapping (address => uint) public balances; //Mapping each address to their balance

// Struct to show address and balances together.
struct ShowBalances{
    address someOne;
    uint    money;
}

ShowBalances[] public showBalances; 

//Constructor - run once when contract deployed 
function Splitter()
payable //Ether can be sent to the contract
{
    //Identifying owner
    owner = msg.sender; 
    
    //Showing balances in Struct
    ShowBalances memory newBalance0;
    newBalance0.someOne = this; 
    newBalance0.money = this.balance;
    showBalances.push(newBalance0);
    ShowBalances memory newBalance1;
    newBalance1.someOne = msg.sender; 
    newBalance1.money = owner.balance; 
    showBalances.push(newBalance1);
    
    //Showing balances in mapping variables
    splitAd = this; 
    balances[splitAd] = this.balance; 
    balances[owner] = owner.balance; 
    
 }


//Send ether to recipient1 and recipient2 (Bob & Carol)
function splitIt(address recipient1, address recipient2, uint amount)
    public
    payable
    returns(bool success)
    {
        //Cases to stop early (throw)
        _amount = amount; 
        if (this.balance < _amount) throw; // if contract does not have enough money, cannot send 
        //but you can send less than the balance of the contract
        if (msg.sender != owner) throw; //if function not sent by owner
        recipientOne = recipient1; 
        recipientTwo = recipient2; 
        newAmount = amount/2;
        recipientOne.transfer(newAmount); //transfer throws only failure - what happens if address for only Bob or only Carol is incorrect?
        recipientTwo.transfer(newAmount); 
        
        //Showing new balances - mapping
        balances[recipientOne] = recipientOne.balance;
        balances[recipientTwo] = recipientTwo.balance;
        balances[owner] = owner.balance; 
        balances[splitAd] = this.balance; 
        
        //Showing new balances - 
        ShowBalances memory newBalance0;
        newBalance0.someOne = this; 
        newBalance0.money = this.balance;
        showBalances.push(newBalance0);
        ShowBalances memory newBalance1;
        newBalance1.someOne = msg.sender; 
        newBalance1.money = owner.balance; 
        showBalances.push(newBalance1);
        ShowBalances memory newBalance2;
        newBalance2.someOne = recipientOne; 
        newBalance2.money += recipientOne.balance; 
        showBalances.push(newBalance2);
        ShowBalances memory newBalance3;
        newBalance3.someOne = recipientTwo; 
        newBalance3.money += recipientTwo.balance;
        showBalances.push(newBalance3);
        return true;
 
    }

//Sending ether to the contract from the webpage, sending as message value
function sendIt()
    public 
    payable
    returns(bool success)
    {
        return true; 
    }

//Self destructing kill switch, only works for contract creator, private
function stopIt()
    private
    returns (bool succes)
    {
    if (msg.sender != owner) throw; //extra check, just in case
    selfdestruct(owner); //send all funds back to owner
    }
}
