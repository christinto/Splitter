pragma solidity ^0.4.2;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Splitter.sol";

contract testSplitter{
    function testThrow(){
        Splitter s = new Splitter(); 
        ThrowProxy t = new ThrowProxy(address(s)); 

        Splitter(address(t)).deposit(account[1], account[2], {from:account[0], value:0})

        bool r = t.execute.gas(200000)(); 

        Assert.isFalse(r, "Should be false, as it should throw.")
    }
}



