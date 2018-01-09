// Import the page's CSS. Webpack will know what to do with it.
import "../stylesheets/app.css";

// Import libraries we need.
import { default as Web3} from 'web3';
import { default as contract } from 'truffle-contract'

// Import our contract artifacts and turn them into usable abstractions.
import splitter_artifacts from '../../build/contracts/Splitter.json'

// MetaCoin is our usable abstraction, which we'll use through the code below.
var Splitter = contract(splitter_artifacts);

// The following code is simple to show off interacting with your contracts.
// As your needs grow you will likely need to change its form and structure.
// For application bootstrapping, check out window.addEventListener below.
var accounts;
var account;

window.App = {
  start: function() {
    var self = this;

    // Bootstrap the MetaCoin abstraction for Use.
    Splitter.setProvider(web3.currentProvider);

    // Get the initial account balance so it can be displayed.
    web3.eth.getAccounts(function(err, accs) {
      if (err != null) {
        alert("There was an error fetching your accounts.");
        return;
      }

      if (accs.length == 0) {
        alert("Couldn't get any accounts! Make sure your Ethereum client is configured correctly.");
        return;
      }

      accounts = accs;
      account = accounts[0];
          
      self.refreshBalance();
      self.refreshContractBal(); 
    });
  },

  setStatus: function(message) {
    var status = document.getElementById("status");
    status.innerHTML = message;
  },

  setStatus2: function(message) {
    var status2 = document.getElementById("status2");
    status2.innerHTML = message;
  },

  refreshBalance: function() {
    var self = this;
    web3.eth.getBalance(account, function(err, bal){
      if (err != null){
        alert("There was an error getting your account balance.");
        var balance_element = document.getElementById("balance");
        balance_element.innerHTML = "Unable to retrieve balance of your account.";
      } else {
        var balance_element = document.getElementById("balance");
        balance_element.innerHTML = web3.fromWei(bal, 'ether');
      }
    })
  },

  refreshContractBal: function() {
    var split;
    Splitter.deployed().then(function(instance){
      split = instance; 
      web3.eth.getBalance(split.address, function(err, bal){
        if (err!=null){
          alert("There was an error getting the contract balance.")
          var contractbalance_element = document.getElementById("contractbalance");
          contractbalance_element.innerHTML = "Unable to retrieve balance of the Splitter contract.";
        } else {
          var contractbalance_element = document.getElementById("contractbalance");
          contractbalance_element.innerHTML = web3.fromWei(bal, 'ether');
        }
      })
    }).then(function(){
      //Do nothing
    }).catch(function(e){
      console.log(e);
    })
  },

  deposit: function() {
    var self = this;

    var amount = parseInt(document.getElementById("amount").value);
    var receiver1 = document.getElementById("receiver1").value;
    var receiver2 = document.getElementById("receiver2").value;

    this.setStatus("Initiating transaction... (please wait)");

    var split;
    Splitter.deployed().then(function(instance) {
      split = instance;
      return split.deposit(receiver1, receiver2, {from: account, value: amount})
    }).then(function(result) {
      self.setStatus("Transaction complete! See console log for transaction results.");
      self.refreshBalance();
      self.refreshContractBal();
      console.log(result); 
    }).catch(function(e) {
      console.log(e);
      self.setStatus("Error sending coin; see log.");
    });
  },

  checkBalance: function(){
    var self = this; 
    var split; 
    var splitbal_element = document.getElementById("splitbalance");
    Splitter.deployed().then(function(instance){
      split = instance; 
      return split.balances(account)
    }).then(function(results){
      console.log(results.toString(10));
      splitbal_element.innerHTML = web3.fromWei(results.toString(10), 'ether')
    }).catch(function(e){
      console.log(e);
    })
  },

  withdrawl: function(){
    var self = this; 

    var split; 
    Splitter.deployed().then(function(instance){
      split = instance; 
      return split.withdraw({from:account, gas:2000000})
    }).then(function(result){
      self.setStatus2("Withdrawl complete! See console log for details.")
      self.refreshBalance(); 
      self.refreshContractBal(); 
      console.log(result)
    }).catch(function(e){
      console.log(e);
      self.setStatus2("There was an error withdrawling your amounts. Please check your balance is great than zero above.")
    })
  }
};

window.addEventListener('load', function() {
  // Checking if Web3 has been injected by the browser (Mist/MetaMask)
  if (typeof web3 !== 'undefined') {
    console.warn("Using web3 detected from external source. If you find that your accounts don't appear or you have 0 MetaCoin, ensure you've configured that source properly. If using MetaMask, see the following link. Feel free to delete this warning. :) http://truffleframework.com/tutorials/truffle-and-metamask")
    // Use Mist/MetaMask's provider
    window.web3 = new Web3(web3.currentProvider);
  } else {
    console.warn("No web3 detected. Falling back to http://127.0.0.1:9545. You should remove this fallback when you deploy live, as it's inherently insecure. Consider switching to Metamask for development. More info here: http://truffleframework.com/tutorials/truffle-and-metamask");
    // fallback - use your fallback strategy (local node / hosted node + in-dapp id mgmt / fail)
    window.web3 = new Web3(new Web3.providers.HttpProvider("http://127.0.0.1:7545"));
  }

  App.start();
});
