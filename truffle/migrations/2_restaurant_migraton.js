var Restaurant = artifacts.require("restaurant");

module.exports = function (deployer) {
    deployer.deploy(Restaurant);
}