const Gems = artifacts.require("Gems");

contract("Gems", accounts => {
  it("should put 100,000,000 GEMs in the first account", () =>
    Gems.deployed()
      .then(instance => instance.balanceOf.call(accounts[0]))
      .then(balance => {
        assert.equal(
          balance.valueOf(),
          100000000*10**18,
          "100,000,000 wasn't in the first account"
        );
      }));

});