# Design Pattern Decisions

## Inter-Contract Execution

`SpaceMiners.sol` has three functions that interact with `Portals.sol` and `Gems.sol`
- `getPortalOwner()` used to pay reward to owner
- `getMintedPortalSupply()` used to get total minted supply for random number generation
- `callMintGems()` used to mint GEMs for players

## Inheritance and Interfaces

- `Portal` interface was used to call `ownerOf()` and `getPortalSupply()` in `Portals.sol` for helping with random number generation.
- `Gem` interface was used to call `mintGems()` and `balanceOf()` in `Gems.sol` for player rewards in GEM.
- `SpaceMiners.sol` inherits `ERC1155.sol` from OpenZeppelin for miner NFTs.
- `SpaceMiners.sol` inherits `RandomNumberConsumer.sol` from Chainlink for random numbers.
- `Portals.sol` inherits `ERC721URIStorage.sol` from OpenZeppelin for portal NFTs.
- `Gems.sol` inherits `ERC20PresetMinterPauser.sol` from OpenZeppelin for ERC20 GEMs token.

## Oracles

- `RandomNumberConsumer.sol` was used in `SpaceMiners.sol` to generate random numbers for the `payout()` function so random portal id's are chosen for GEM reward.

## Access Control Design Patterns

- `Ownable.sol` was used in two functions: `changePortalMintingFee()` and `generateRandomNumber()` to protect functions that should only be called by the contract owner. 
- `changePortalMintingFee()` can be found in `Portals.sol`, and `generateRandomNumber()` can be found in `SpaceMiners.sol`.