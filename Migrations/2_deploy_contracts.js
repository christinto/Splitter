var Splitter = artifacts.require("./Splitter.sol");

/*Deploys Splitter contract from first account. */
module.exports = function(deployer) {
  deployer.deploy(Splitter);
};
