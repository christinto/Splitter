//Splitter - Small Project 


pragma solidity ^0.4.6;

contract Splitter{
    //Alice or whomever sends money to the contract to be split.
    address public owner;
    uint    public  theRemainder; 
    //Mapping each address to their balance. 
    mapping (address => uint) public balances; 
    
//Can be listened to on Javascript end, displyed on website. I want to display balances
//for all three people and the contract itself
event trackingBalances(address thePerson, uint amount);

//Constructor - run once when contract deployed. Not payable to avoid confusion
//of sending ether during deployment. 
function Splitter()
{
    //Identifying owner of the contract
    owner = msg.sender;
}

modifier isValueLessThanZero(uint value) {
  if (!(value > 0)){
      throw; 
  } 
  else{
    _;  
  }
}

modifier onlyOwner {
    if (owner != msg.sender){
        throw; 
    } else {
        _;
    }
}


//Takes in the amount to send to Bob & Carol
function deposit(address recipient1, address recipient2)
    isValueLessThanZero(msg.value)
    public
    payable
    returns(bool success)

{
        //Trying alternatives, favor recipient 1 in the case of uneven numbers
        theRemainder = msg.value % 2;
        //Mapping balances, favoring first recipient. 
        balances[recipient1] += msg.value/2 + theRemainder; 
        balances[recipient2] += msg.value/2; 
        
        trackingBalances(msg.sender, msg.sender.balance);
        trackingBalances(recipient1, balances[recipient1]);
        trackingBalances(recipient2, balances[recipient2]);
        trackingBalances(this, this.balance);
        
        return true;

}



//Sending funds to Bob or Carol. Only the action. 
function withdraw()
    public 
    returns (bool success)
{
    //Cases to throw - how to make sure only Bob or Carol can withdraw funds?
    //Use the balances identified above to send money. This should make sure that 
    //only those with identified balances can be sent their balances
    //Bob is paying gas when withdrawing - can contract send gas to another funciton so he doesn't have to pay?
    if (balances[msg.sender] <= 0) throw;
    var toSend = balances[msg.sender];
    balances[msg.sender] -= balances[msg.sender];
    //In case trying to have contract pay gas. I still couldn't get this work correctly...
    // if (!msg.sender.call.gas(3000000).value(toSend)()) throw; 
    if (!msg.sender.send(toSend)) throw; 
    trackingBalances(this, this.balance);
    trackingBalances(msg.sender, 0);
    
    return true; 
}


//Self destructing kill switch, only works for contract creator
function stopIt()
    onlyOwner()
    public 
{
    //Can only self distruct via the owner of the contract. 
    selfdestruct(owner); //send all funds back to owner
    //No returns
}

}

contract ThrowProxy {
  address public target;
  bytes data;

  function ThrowProxy(address _target) {
    target = _target;
  }

  //prime the data using the fallback function.
  function() {
    data = msg.data;
  }

  function execute() returns (bool) {
    return target.call(data);
  }
}








