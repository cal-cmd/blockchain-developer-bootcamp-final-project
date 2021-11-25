const SpaceMiners = artifacts.require("SpaceMiners");
const Portals = artifacts.require("Portals");
const Gems = artifacts.require("Gems");

contract("SpaceMiners", async accounts => {
  it("should mint 1 miner when payment = ETH fee", async () => {
    const instance = await SpaceMiners.deployed();
    const mintMiner = await instance.mintMiner(1, {value: web3.utils.toWei('1', 'ether')});
    const balanceOf = await instance.balanceOf(accounts[0], 1);
    const tx = await web3.eth.getTransaction(mintMiner.receipt.transactionHash);
    
    assert.equal(balanceOf, 1, "miner balance still 0");
    assert.equal(tx.value, web3.utils.toWei('1', 'ether'), "check transaction value");
  });
  it("should warp miner through portal and increase activeMiners count", async () => {
    const instance = await SpaceMiners.deployed();
    const gemsInstance = await Gems.deployed();
    const mintMiner = await instance.mintMiner(0, {value: web3.utils.toWei('1', 'ether')});
    const warp = await instance.warp(0);
    const activeMiners = await instance.getActiveMiners(0);
    
    assert.equal(activeMiners, 1, "activeMiners count still 0");
  });
  it("should mint GEM for player upon miner return", async () => {
    const instance = await SpaceMiners.deployed();
    const gemsInstance = await Gems.deployed();
    const mintMiner = await instance.mintMiner(3, {value: web3.utils.toWei('1', 'ether')});
    const warp = await instance.warp(3);
    const payout = await instance.payout(3, gemsInstance.address);
    const gemsBalance = await gemsInstance.balanceOf(accounts[0]);
    // 100000000*10**18 accounts for initial GEMs minted to sender
    assert.equal(gemsBalance, (100000000*10**18) + 48, "Didn't mint GEMs");
  });
  it("should get total portal supply for random number", async () => {
    const instance = await SpaceMiners.deployed();
    const portalsInstance = await Portals.deployed();
    const mintPortal = await portalsInstance.mintPortal(accounts[0], "", {value: web3.utils.toWei('1', 'ether')});
    const getMintedPortalSupply = await instance.getMintedPortalSupply(portalsInstance.address);

    assert.equal(getMintedPortalSupply, 1, "minted supply should be 1");
  });
});