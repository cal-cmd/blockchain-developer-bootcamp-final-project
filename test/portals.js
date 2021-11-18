const Portals = artifacts.require("Portals");

contract("Portals", async accounts => {
  it("should only be able to mint up to 10 portals", async () => {
    const instance = await Portals.deployed();
    const mintPortals = await instance.mintPortals(accounts[0], "", 10, {value: web3.utils.toWei('10', 'ether')});
    const balanceOf = await instance.balanceOf(accounts[0]);
    const tx = await web3.eth.getTransaction(mintPortals.receipt.transactionHash);
    
    assert.equal(balanceOf, 10, "portal balance != 10");
    assert.equal(tx.value, web3.utils.toWei('10', 'ether'), "check transaction value");
  });
});