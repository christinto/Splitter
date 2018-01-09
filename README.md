# Splitter
Splitter Smart Contract

B9Labs Practice Example. 

1. To run the Dapp, clone the repository above to your machine. 
2. Run `npm install` to install dependancies. (This example was completed using Webpack.) 
3. Using Testrpc, Ganache or other test network, deploy the contract using Truffle. 
4. Run `npm run dev` to serve, and you can access the page through http://localhost:8080/.

Contract Description:  
* There are 3 people: Alice, Bob and Carol
* We can see the balance of the Splitter contract on the web page
* Whenever Alice sends ether to the contract, half of it goes to Bob and the other half to Carol
* We can see the balances of Alice. 
* We can send ether to it from the web page
* Different people impersonating Alice, Bob and Carol, all cooperating on a test net.

Stretch goals:
* Add a kill switch to the whole contract
* Make the contract a utility that can be used by David, Emma and anybody with an address
* Cover potentially bad input datat - Example Practice

Improvements for future: 
* Better control over ownership of contract and possible transfer of ownership. 
* Make the contract pausible. 
* Manipulate selfdestruct function so that the contract would selfdestruct to another contract that tracks the balances of those using the contract, so people could still withdraw their own funds. 
* Allow the user to switch accounts for interaction with the webpage. 


