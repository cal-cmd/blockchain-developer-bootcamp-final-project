const SpaceMiners = artifacts.require("SpaceMiners");
const Portals = artifacts.require("Portals");
const Gems = artifacts.require("Gems");

contract("SpaceMiners", async accounts => {
  // will attempt to mint miner with correct minting fee then check balance and transaction value
  it("should mint one miner when payment is equal to minting fee", async () => {
    const instance = await SpaceMiners.deployed();
    const mintMiner = await instance.mintMiner(1, {value: web3.utils.toWei('1', 'wei')});
    const balanceOf = await instance.balanceOf(accounts[0], 1);
    const tx = await web3.eth.getTransaction(mintMiner.receipt.transactionHash);
    
    assert.equal(balanceOf, 1, "miner balance still 0");
    assert.equal(tx.value, web3.utils.toWei('1', 'wei'), "check transaction value");
  });
  // will warp one miner and then check if activeMiners mapping increased by 1
  it("should warp the miner through portal and increase activeMiners count", async () => {
    const instance = await SpaceMiners.deployed();
    const gemsInstance = await Gems.deployed();
    const mintMiner = await instance.mintMiner(0, {value: web3.utils.toWei('1', 'wei')});
    const warp = await instance.warp(0);
    const activeMiners = await instance.getActiveMiners(0);
    
    assert.equal(activeMiners, 1, "activeMiners count still 0");
  });
  // will call Portals.sol to get minted portal supply for helping with random number generation 
  it("should get minted portal supply for random number generation", async () => {
    const instance = await SpaceMiners.deployed();
    const portalsInstance = await Portals.deployed();
    const mintPortal = await portalsInstance.mintPortal(accounts[0], "", {value: web3.utils.toWei('1', 'wei')});
    const getMintedPortalSupply = await instance.getMintedPortalSupply(portalsInstance.address);

    assert.equal(getMintedPortalSupply, 1, "minted supply should be 1");
  });
  // will mint portal and miner to sender then warp, and afterwards attempt payout and check balance
  // as the account should be rewarded the full amount since you own the portal too
  it("should mint GEM for player & portal owner upon miner return", async () => {
    const instance = await SpaceMiners.deployed();
    const gemsInstance = await Gems.deployed();
    const portalsInstance = await Portals.deployed();
    const mintPortal = await portalsInstance.mintPortal(accounts[0], "", {value: web3.utils.toWei('1', 'wei')});
    const mintMiner = await instance.mintMiner(3, {value: web3.utils.toWei('1', 'wei')});
    const warp = await instance.warp(3);
    const payout = await instance.payout(3, gemsInstance.address, portalsInstance.address);
    const gemsBalance = await gemsInstance.balanceOf(accounts[0]);
    // Since msg.sender owns both the portal & miner the full reward is transferred here
    assert.equal(gemsBalance, (100000000*10**18) + 48, "Didn't mint GEMs");
  });
});