/* Pull in Splitter Contract */
let Splitter = artifacts.require("./Splitter.sol");

contract('Splitter', function(accounts){
  
  let contract; //Instance of contract deployed
  //Addresses to save
  let owner =  accounts[0]; //Alice
  let bob = accounts[1]; //Bob
  let carol = accounts[2]; //Carol

  //Amounts sent to contract
  let amount1 = 10; //Test an even number
  let amount2 = 9 //Test an odd number
  let amount3 = 0; //Test zero 

  /* Steps to take before each test run, deploy contract each time to start
  at same base case. */
  beforeEach(async function(){
    contract = await Splitter.new(); 
  });

   //Contract should be owned by Alice
  describe("Ownership", async function() {
    it("Should be owned by Alice.", async function(){
      let splitterowner = await contract.owner({from:owner})
      assert.strictEqual(splitterowner, owner, "Contract not owned by Alice.")
    });
  })
 
  
  /* Contract should take in Alice's (or whomever's) even deposits and split evenly, contract should also 
  assign correct balances to Bob & Carol. */
  describe("Even deposits", async function(){
    it("Should take Alice's even deposits and split evenly", async function(){
      try {
        await contract.deposit(bob, carol, {from: owner, value: amount1});
      } catch (e) {
        return console.log(e);
      } finally {
        //Check contract balance
        let contractAddress = contract.address; 
        let contractBal = web3.eth.getBalance(contractAddress);
        assert.equal(contractBal.toString(10), web3.toWei(amount1, "wei"), "Deposit not received.")
        //Check balance assigned to Bob
        let bobsbalance = await contract.balances(bob);
        assert.strictEqual(bobsbalance.toString(10), web3.toWei(5, "wei"), "Bob's value was not assigned.")
        //Check balance assigned to Carol
        let carolsbalance = await contract.balances(carol);
        assert.strictEqual(carolsbalance.toString(10), web3.toWei(5, "wei"), "Bob's value was not assigned.")
      }
    })
  })

  /* Contract should take in Alice's (or whomever's) odd deposits and assign balances, favoring the first address given. */
  describe("Odd deposits", async function(){
    it("Should take Alice's odd deposits and split favoring the first address", async function(){
      try {
        await contract.deposit(bob, carol, {from: owner, value: amount2});
      } catch (e) {
        return console.log(e);
      } finally {
        //Check contract balance
        let contractAddress = contract.address; 
        let contractBal = web3.eth.getBalance(contractAddress);
        assert.equal(contractBal.toString(10), amount2, "Deposit not received.")
        //Check balance assigned to Bob
        let bobsbalance = await contract.balances(bob);
        assert.strictEqual(bobsbalance.toString(10), web3.toWei(5, "wei"), "Bob's value was not assigned.")
        //Check balance assigned to Carol
        let carolsbalance = await contract.balances(carol);
        assert.strictEqual(carolsbalance.toString(10), web3.toWei(4, "wei"), "Bob's value was not assigned.")
      }
    })
  })

  /* Contract should allow Bob to withdrawl his assigned balances and only that. */
  describe("Withdrawling assigned balances", async function(){
    it("Should allow Bob & Carol to withdrawl the fund split between them.", async function(){
      try {
        await contract.deposit(bob, carol, {from: owner, value: amount1});
        await contract.withdraw({from:bob});
        await contract.withdraw({from:carol})
      } catch (e) {
        return console.log(e);
      } finally {
        //Check balance assigned to Bob, should be zero after withdrawl
        let bobsbalance = await contract.balances(bob);
        assert.strictEqual(bobsbalance.toString(10), web3.toWei(0, "wei"), "Bob was not able to withdrawl funds.");
        //Check balance assigned to Carol, should be zero after withdrawl
        let carolsbalance = await contract.balances(carol);
        assert.strictEqual(carolsbalance.toString(10), web3.toWei(0, "wei"), "Carol was not able to withdrawl funds.")
      }
    })
  })
  
  /* Testing for self destruct to work with correct owner. */

  describe("Selfdestruct tests", async function(){
    it("Should not allow Bob to selfdestruct", async function(){
      try {
        await contract.stopIt({from: bob})
      } catch (e) {
        return 
        //No returns because there should be an error here. 
      } finally {
        let contractcode = web3.eth.getCode(contract.address);
        assert.isOk(contractcode, "Contract was not selfdestructed as expected.")
      }
    })
  })

});

