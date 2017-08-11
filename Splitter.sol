//Splitter - Small Project 
//3 people - Alice, Bob & Carol 
//Balance can be seen on splitter contract webpage
//Whenever Alice sends ether, half go to Bob and half goes to Carol
//Can see the balances of Alice, Bob & Carol on the webpage
//Ether can be send to the contract from the webpage

pragma solidity ^0.4.6;

contract Splitter{
    address public owner; //Alice
    address public recipientOne; 
    address public recipientTwo; 
    uint    public ownerBalance;
    uint    public amountToSend;
    uint    public newAmount;
    mapping (address => uint) public balances; //Re: solidity intros getting balances
    //Not really sure of what 'mapping' is doing

struct ShowBalances{
    address someOne;
    uint    money;
}

ShowBalances[] public showBalances; 

//Constructor - run once when contract deployed 
function Splitter()
payable
{
    //Showing balances 
    ShowBalances memory newBalance;
    newBalance.someOne = msg.sender; 
    newBalance.money = msg.value;
    showBalances.push(newBalance);
    //Identifying owner
    owner = msg.sender;
}

//Send ether to recipient1 and recipient2
function sendIt(address recipient1, address recipient2, uint amount)
    public
    payable
    returns(bool success)
    {
        //Cases to stop early (throw)
        //if (msg.value == 0) throw;
        //if (msg.sender != owner) throw;
        //Sending balances
        recipientOne = recipient1; 
        recipientTwo = recipient2; 
        amountToSend = msg.value; 
        newAmount = amount/2;
        recipientOne.transfer(newAmount);
        recipientTwo.transfer(newAmount);
        balances[recipientOne] += newAmount;
        balances[recipientTwo] += newAmount;
        balances[owner] -= newAmount;
        //Showing new balances
        ShowBalances memory newBalance;
        newBalance.someOne = recipient1; 
        newBalance.money += newAmount; 
        showBalances.push(newBalance);
        newBalance.someOne = recipient2; 
        newBalance.money += newAmount;
        showBalances.push(newBalance);
        return true;
 
    }
}


    
