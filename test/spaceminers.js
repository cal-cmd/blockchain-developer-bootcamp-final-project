const SpaceMiners = artifacts.require("SpaceMiners");

contract("SpaceMiners", async accounts => {
  it("should mint 1 miner when payment is >= ETH fee", async () => {
    const instance = await SpaceMiners.deployed();
    const mintMiner = await instance.mintMiner(1, {value: web3.utils.toWei('1', 'ether')});
    const balanceOf = await instance.balanceOf(accounts[0], 1);
    const tx = await web3.eth.getTransaction(mintMiner.receipt.transactionHash);
    
    assert.equal(balanceOf, 1, "miner balance still 0");
    assert.equal(tx.value, web3.utils.toWei('1', 'ether'), "check transaction value");
  });
});