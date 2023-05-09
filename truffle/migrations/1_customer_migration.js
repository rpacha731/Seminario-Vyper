var Customer = artifacts.require("customer");

module.exports = function (deployer) {
    deployer.deploy(Customer);
}