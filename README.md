# Space Miners

A play-to-earn game where miners travel to the far ends of the galaxy through portals to recover GEMs! A miners payout will be effected by the bag size (GEMs capacity each trip) and the return time from trips. On launch players will be able to mint a limited amount of portals to assist miners in travelling the galaxy for a fee. Portal owners can receive these fees by chance upon a miners return, and before-hand a random number is generated using Chainlink's VRF to prevent foul play and decide which portal will be rewarded.

# Requirements & Setup

- Node >=12.22.7
- Truffle

1 - `git clone https://github.com/caleb-berry/blockchain-developer-bootcamp-final-project.git`

2 - `cd blockchain-developer-bootcamp-final-project`

3 - `npm install`

4 - `truffle test` - Will execute six tests for the three contracts

5 - Check "Environment Variables" below and make sure file is populated to deploy to testnet.

6 - `truffle migrate --network rinkeby` 

# Environment Variables

Create a `.env` file in the main directory and populate with the following:

`MNEMONIC=test test test test test test test test test test test test` please fill out with your wallet's mnemonic.
`INFURA_KEY=xxxxxxxxxxxxxxxxxxxxxxxxx` project id key from Infura.io

# Frontend

Live website: https://spaceminers.surge.sh/debug

Front github link: https://github.com/caleb-berry/final-project-frontend (Used a different repo since scaffold-eth uses Hardhat instead of Truffle)

# Directory Structure

Contracts are located in `/contracts`
Migration files are located in `/migrations`
Tests are located in `/test`

# ETH Address for NFT

`0x1931BD7C54EA550C6D657b050538C142e6Ad4422`
