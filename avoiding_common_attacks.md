# Avoiding Common Attacks

## Using Specific Compiler Pragma (SWC-103)

All contracts are compiled using `v0.8.0`

## Proper Use of Require, Assert and Revert (SWC-128)

`SpaceMiners.sol` uses `require()` in `warp()` to prevent players from warping miners that are already active, limiting the maximum amount of active miners, and prevents further warping until all payouts are received if you have more than ten payouts waiting. Otherwise the loop would become too big and block gas limit will be reached.

## Checks-Effects-Interactions (SWC-107)

`payout()` in `SpaceMiners.sol` subtracts the activeMiner counter before transferring GEMs to miner and portal owners to protect against `Re-entrancy`.