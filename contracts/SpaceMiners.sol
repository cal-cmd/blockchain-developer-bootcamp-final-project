// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

/// @title SpaceMiners contract for miners & portals

contract SpaceMiners is ERC1155 {

    /// Event called after minting miner
    event MinerMinted(address indexed _sender, uint indexed _amount, uint _minerId);

    struct Miner {
        uint bagSize;
        uint warpFee;
        uint returnTime;
        uint departTime;
        uint fee;
        bool active;
    }
    /// @dev to keep track of miners data and travel status
    Miner[] public miners;

    uint256 public constant MINER_1 = 0;
    uint256 public constant MINER_2 = 1;
    uint256 public constant MINER_3 = 2;
    uint256 public constant MINER_4 = 3;
    uint256 public constant PORTAL = 4;

    constructor() ERC1155("https://game.example/api/item/") {
        miners.push(Miner({bagSize: 16, warpFee: 5, returnTime: 48, departTime: 0, fee: 1 ether, active: false}));
        miners.push(Miner({bagSize: 24, warpFee: 4, returnTime: 39, departTime: 0, fee: 1 ether, active: false}));
        miners.push(Miner({bagSize: 32, warpFee: 4, returnTime: 31, departTime: 0, fee: 1 ether, active: false}));
        miners.push(Miner({bagSize: 48, warpFee: 3, returnTime: 24, departTime: 0, fee: 1 ether, active: false}));
    }

    /// @dev Called by sender to mint miner for fee
    /// @param _minerId id of the miner (0-3)
    function mintMiner(uint _minerId) public payable {
        require(msg.value >= miners[_minerId].fee);
        _mintMiner(_minerId);
    }
    /// @dev internal miner minting function
    /// @param _minerId id of the miner (0-3)
    function _mintMiner(uint _minerId) internal {
        _mint(msg.sender, _minerId, 1, "");
        emit MinerMinted(msg.sender, msg.value, _minerId);
    }
}