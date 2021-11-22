// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

/// @title Portals contract for SpaceMiners

contract Portals is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    /// @notice fee to mint portal
    uint public portalFee = 1 ether;

    constructor() ERC721("Portals", "PRT") {}

    /// @notice function to mint portals for fee
    /// @param player minter of portal
    /// @param tokenURI token URI
    /// @dev minting fee = portalFee (default: 1 ether) 
    function mintPortal(address player, string memory tokenURI) public payable returns (uint256) {
        require(msg.value >= portalFee, "");
        _tokenIds.increment();
        require(_tokenIds.current() <= 10, "only up to 10 portals can be minted");

        uint256 newItemId = _tokenIds.current();
        _mint(player, newItemId);
        _setTokenURI(newItemId, tokenURI);

        return newItemId;
    }

    /// @notice Change portal minting fee, can only be called by owner
    /// @param _fee fee for minting
    function changePortalFee(uint _fee) public onlyOwner {
        portalFee = _fee;
    }
}