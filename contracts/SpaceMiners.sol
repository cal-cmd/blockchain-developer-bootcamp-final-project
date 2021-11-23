// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title Portal ownerOf abi for SpaceMiners portals contract
interface Portal {
    function ownerOf(uint256 tokenId) external view returns (address);
}

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

/// @title SpaceMiners contract for miners
contract SpaceMiners is ERC1155 {

    struct Miner {
        uint bagSize;
        uint warpFee;
        uint returnTime;
        uint departTime;
        uint fee;
        bool active;
    }

    Miner[] public miners;

    uint256 public constant MINER_1 = 0;
    uint256 public constant MINER_2 = 1;
    uint256 public constant MINER_3 = 2;
    uint256 public constant MINER_4 = 3;

    constructor() ERC1155("https://game.example/api/item/") {
        miners.push(Miner({bagSize: 16, warpFee: 5, returnTime: 48, departTime: 0, fee: 1 ether, active: false}));
        miners.push(Miner({bagSize: 24, warpFee: 4, returnTime: 39, departTime: 0, fee: 1 ether, active: false}));
        miners.push(Miner({bagSize: 32, warpFee: 4, returnTime: 31, departTime: 0, fee: 1 ether, active: false}));
        miners.push(Miner({bagSize: 48, warpFee: 3, returnTime: 24, departTime: 0, fee: 1 ether, active: false}));
    }

    /// @notice Mint miner for fee
    /// @param _minerId id of the miner (0-3)
    function mintMiner(uint _minerId) public payable {
        require(msg.value == miners[_minerId].fee);
        _mint(msg.sender, _minerId, 1, "");
    }

    /// @notice Checks owner of portal
    /// @param _id Portal id
    /// @param _contractAddress Portal contract address
    function checkPortalOwner(uint _id, address _contractAddress) internal returns(address) {
        Portal portalsContract = Portal(_contractAddress);
        return portalsContract.ownerOf(_id);
    }


}