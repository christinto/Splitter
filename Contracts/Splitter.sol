//Splitter - Small Project 
//3 people - Alice, Bob & Carol 
//Balances can be seen on splitter contract webpage
//Whenever Alice sends ether - Alice sends 
//Half go to Bob and half goes to Carol - pulled 
//Can see the balances of Alice, Bob & Carol on the webpage
//Ether can be send to the contract from the webpage

pragma solidity ^0.4.6;//Splitter - Small Project 
//3 people - Alice, Bob & Carol 
//Balances can be seen on splitter contract webpage
//Whenever Alice sends ether - Alice sends 
//Half go to Bob and half goes to Carol - pulled 
//Can see the balances of Alice, Bob & Carol on the webpage
//Ether can be send to the contract from the webpage

pragma solidity ^0.4.6;

contract Splitter{
    address public owner; //"Alice"
    //Mapping each address to their balance. Only need to
    //know balances by account
    mapping (address => uint) public balances; 


//Constructor - run once when contract deployed 
function Splitter()
//Not payable to avoid confusion of sending Ether during deployment. 
{
    //Identifying owner
    owner = msg.sender;
}


//Takes in the amount to send to Bob & Carol
function deposit(address recipient1, address recipient2)
    public
    payable
    returns(bool success)
{
        //Cases to stop early (throw)
        if (msg.sender != owner) throw; //if function not sent by owner
        if (msg.value < 0) throw; 
        //Base unit for contracts is wei, if division of odd number, remainder 
        //stays with the contract. Best to throw contract if there is an odd value
        //with a remainder...(?)
        if (msg.value % 2 !=0) throw; 
        //Mapping balances - showing balance of contract
        balances[this] += msg.value; 
        //Go ahead and update balance of recipients since money is already here (?)
        balances[recipient1] += msg.value/2; 
        balances[recipient2] += msg.value/2; 
        return true;
}

//Sending funds to Bob or Carol. Only the action. 
function withdraw()
    public 
    returns (bool success)
{
    //Assuming no need to make this payable as funds paid through deposit()
    //Cases to throw - how to make sure only Bob or Carol can withdraw funds?
    //Use the balances identified above to send money. This should make sure that 
    //only those with identified balances can be sent their balances
    //Bob is paying gas when withdrawing - can contract send gas to another funciton so he doesn't have to pay?
    if (balances[msg.sender] <=0 ) throw;
    msg.sender.call.gas(3000000)(secondWithdraw()); 
    return true; 
}

function secondWithdraw()
    private
    returns (bool success)
{
    if (balances[msg.sender] <= 0) throw; 
    if (!msg.sender.send(balances[msg.sender])) throw;
    //What if Bob comes back and tries to steal Carol's funds before she gets them? 
    balances[msg.sender] -= balances[msg.sender];
    return true;
}
   
    
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


