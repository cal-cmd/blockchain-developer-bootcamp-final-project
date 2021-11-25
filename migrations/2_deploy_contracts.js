const Gems = artifacts.require('Gems');
const SpaceMiners = artifacts.require('SpaceMiners');
const Portals = artifacts.require('Portals');

module.exports = async function (deployer) {
  await deployer.deploy(SpaceMiners);
  await deployer.deploy(Gems, SpaceMiners.address);
  await deployer.deploy(Portals);
};