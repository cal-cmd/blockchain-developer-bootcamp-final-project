// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Roles.sol";

/// @title Gems contract for space miners

contract Gems is ERC20 {
    using Roles for Roles.Role;
    Roles.Role private _minter;

    constructor(address[] memory minters) ERC20('GEMS', 'GEM') {
        _mint(msg.sender, 100000000*10**18);

        for (uint256 i = 0; i < minters.length; ++i) {
            _minters.add(minters[i]);
        }
    }

    /// @notice Used by SpaceMiners.sol contract to mint gems for players
    function mintGems(address _player, uint amount) external {
        require(_minters.has(msg.sender), "DOES_NOT_HAVE_MINTER_ROLE");
        _mint(_player, amount);
    }
}