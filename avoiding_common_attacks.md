# Avoiding Common Attacks

## Using Specific Compiler Pragma

All contracts are using `v0.8.0`

## Proper Use of Require, Assert and Revert 

`Portals.sol` uses `require()` in `mintPortal()` to check if the transaction value sent is equal to the `portalMintingFee`.
`SpaceMiners.sol` uses `require()` in `warp()` to prevent players from warping miners that are already active, limiting the maximum amount of active miners, and prevents further warping until all payouts are received if you have more than ten payouts waiting.

## Checks-Effects-Interactions

`payout()` in `SpaceMiners.sol` subtracts the activeMiner counter before transferring GEMs to miner and portal owners.