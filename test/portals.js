const Portals = artifacts.require("Portals");

contract("Portals", async accounts => {
  // on line 26 in Portals.sol there's a require() check that prevents
  // more than 10 portals from being minted and keeps track by using _tokenIds
  // this tries to mint 11 portals and then checks the balance which should still be 10
  it("should only be able to mint up to 10 portals", async () => {
    const instance = await Portals.deployed();
    try {
      for(let i=0; i < 11; i++) {
        const mintPortal = await instance.mintPortal(accounts[0], "", {value: web3.utils.toWei('1', 'wei')});
      }
    } catch(error) {}

    const balanceOf = await instance.balanceOf(accounts[0]);
    assert.equal(balanceOf, 10, "shouldn't go over a balance of 10");
  });
});