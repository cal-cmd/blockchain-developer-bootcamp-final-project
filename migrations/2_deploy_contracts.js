const Gems = artifacts.require('Gems');
const SpaceMiners = artifacts.require('SpaceMiners');

module.exports = async function (deployer) {
  await deployer.deploy(Gems);
  await deployer.deploy(SpaceMiners);
};