// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract SpaceMiners is ERC1155 {

    struct Miner {
        uint bagSize;
        uint warpFee;
        uint tripTime;
    }

    Miner[] public miners;

    uint256 public constant MINER_1 = 0;
    uint256 public constant MINER_2 = 1;
    uint256 public constant MINER_3 = 2;
    uint256 public constant MINER_4 = 3;
    uint256 public constant PORTAL = 4;

    constructor() ERC1155("https://game.example/api/item/") {
        _mint(msg.sender, MINER_1, 10**18, "");
        _mint(msg.sender, MINER_2, 10**15, "");
        _mint(msg.sender, MINER_3, 10, "");
        _mint(msg.sender, MINER_4, 10, "");
        _mint(msg.sender, PORTAL, 1, "");

        miners.push(Miner({bagSize: 16, warpFee: 5, tripTime: 48}));
        miners.push(Miner({bagSize: 24, warpFee: 4, tripTime: 39}));
        miners.push(Miner({bagSize: 32, warpFee: 4, tripTime: 31}));
        miners.push(Miner({bagSize: 48, warpFee: 3, tripTime: 24}));
    }
}