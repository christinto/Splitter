var Splitter = artifacts.require("./Splitter.sol");
web3.eth.getTransactionReceiptMined = require("./getTransactionReceiptMined.js");

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
  var amount1 = web3.toWei(10, "ether"); //Test an even number
  var amount2 = web3.toWei(9, "ether"); //Test an odd number
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
  it("Should take Alice's deposits.", function(){
    var alicesDeposit;
    var contractAddress; 
    return contract.deposit(bob, carol, {from:owner, gas: 3000000, value: amount1})
    .then(function(txn){
      contractAddress = contract.address; 
      alicesDeposit = web3.eth.getBalance(contractAddress);
      assert.equal(alicesDeposit.toString(10), amount1, "Even amount not received.");
      });
    });

  //Second test, contract should give funds to Bob when he calls it
  it("Should give funds to Bob.", function(){
      var bobsBalNew; 
      var diff; 
      var bobsBalOld = web3.eth.getBalance(accounts[1]);
      var carolsBalNew; 
      var diff2; 
      var carolsBalOld = web3.eth.getBalance(accounts[2]);
      var gasCost;
      return contract.deposit(bob, carol, {from:owner, value:amount1})
      .then(function(txn){
      return contract.withdraw({from:bob})
      .then(function(txn2){
        bobsBalNew = web3.eth.getBalance(bob); 
        diff = bobsBalNew.minus(bobsBalOld);
        carolsBalNew = web3.eth.getBalance(carol);
        diff2 = carolsBalOld.minus(carolsBalNew);
        assert.equal(diff.toString(10), amount1/2, "Bob didn't get correct funds.")
        assert.equal(diff2.toString(10), amount1/2, "Carol didn't get the correct funds.")         
        });
     });
  });
});

