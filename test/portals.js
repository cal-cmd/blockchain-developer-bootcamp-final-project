const Portals = artifacts.require("Portals");

contract("Portals", async accounts => {
  it("should only be able to mint up to 10 portals", async () => {
    const instance = await Portals.deployed();
    try {
      for(let i=0; i < 11; i++) {
        const mintPortal = await instance.mintPortal(accounts[0], "", {value: web3.utils.toWei('1', 'ether')});
      }
    } catch(error) {}

    const balanceOf = await instance.balanceOf(accounts[0]);
    assert.equal(balanceOf, 10, "shouldn't go over a balance of 10");
  });
});