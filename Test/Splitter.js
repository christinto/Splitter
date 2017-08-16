var Splitter = artifacts.require("./Splitter.sol");

//Already have Chaijs library here
/*What should we test with splitter? 
First splitter should allow "Alice" to send the Ether to the contract - compare before and after balances of Alice?
Second splitter should send coins to Carol & Bob, compare the before and after balances 
*/

contract('Splitter', function(accounts){
  //Variables to establish here
  var contract; //Instance of contract deployed
  //Address to save
  var owner =  accounts[0]; //Alice
  var bob = accounts[1]; //Bob
  var carol = accounts[2]; //Carol
  //Amounts sent to contract
  var amount1 = 10; //Test an even number
  var amount2 = 9; //Test an odd number
  var amount3 = 0; //Test zero 

  //Steps to take before each test runs, deploy contract each time to 
  //start at "same base case"
  beforeEach(function(){
    return Splitter.new({from:owner})
    //Store the instance
    .then(function(instance){
      contract = instance; 
    });
  });

  //First test, contract should be owned by Alice
  it("Should be owned by Alice.", function(){
    return contract.owner({from:owner})
    .then(function(_owner){
      assert.strictEqual(_owner, owner, "Contract not owned by Alice.")
    });
  });

  //First test, contract should take in Alice's even deposits
  it("Should take Alice's even deposits.", function(){
    var alicesDeposit; 
    alicesCurBalance = web3.eth.getBalance(accounts[0]);
    //I don't know whether to use the mapped balances or the actual
    //account balances here
    return contract.deposit({from:owner, value: amount1}, bob, carol)
    .then(function(txn){
      return contract.balances({from:owner})
      .then(function(_balances){
        alicesDeposit = _balances; 
        assert.equal(balances[bob], amount/2, "Even amount not received.")
      });
    //Originally wanted to compare the balance of the contract to what was sent
    //from Alice - could not find a way to call this here because I didn't know 
    //how to get the contract address into web3.eth.getBalance()
    //Trying to see if I can compare Alice's old balance & new balance with the 
    //difference
    // var alicesNewBalance;
    // var theDiff; 
    // alicesNewBalance = web3.eth.getBalance(accounts[0]);
    // theDiff = alicesCurBalance-alicesNewBalance; 
    // //I keep getting "BigNumber" errors...
    // assert.equal(theDiff.toString(10), amount1.toString(10), "Even amount not received.") 
    });
  });

  //Second test, contract should throw odd deposits 
  //Third test, contract should throw 0 value deposits

  //Fourth/Fifth test, contract should give funds to Bob or Carol 
  it("Should give funds to Bob", function (){
    return contract.withdraw({from:bob});
    then(function(txn){
      
    })
  })
})
