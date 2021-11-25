// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/presets/ERC20PresetMinterPauser.sol";

/// @title Gems contract for space miners

contract Gems is ERC20PresetMinterPauser {
    bytes32 public constant MINTER = keccak256("MINTER");

    // for the sake of keeping testing easy for everyone will make minter role msg.sender (it will typically be the SpaceMiners.sol contract address)
    constructor(address _gameContractAddress) ERC20PresetMinterPauser('GEMS', 'GEM') {
        _mint(msg.sender, 100000000*10**18);
        grantRole(MINTER, _gameContractAddress);
    }

    /// @notice Used by SpaceMiners.sol contract to mint gems for players
    function mintGems(address _player, uint _amount) external {
        require(hasRole(MINTER, msg.sender));
        _mint(_player, _amount);
    }
}