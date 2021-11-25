// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";
 
contract RandomNumberConsumer is VRFConsumerBase {
    
    bytes32 internal keyHash;
    uint256 internal fee;
    
    uint256 public randomResult;
    
    constructor() 
        VRFConsumerBase(
            0xb3dCcb4Cf7a26f6cf6B120Cf5A73875B7BBc655B, // VRF Coordinator
            0x01BE23585060835E02B77ef475b0Cc51aA1e0709  // LINK Token
        )
    {
        keyHash = 0x2ed0feb3e7fd2022120aa84fab1945545a9f2ffc9076fd6156fa96eaff4c1311;
        fee = 0.1 * 10 ** 18; // 0.1 LINK (Varies by network)
    }
    
    /** 
     * Requests randomness 
     */
    function getRandomNumber() public returns (bytes32 requestId) {
        require(LINK.balanceOf(address(this)) >= fee, "Not enough LINK - fill contract with faucet");
        return requestRandomness(keyHash, fee);
    }

    /**
     * Callback function used by VRF Coordinator
     */
    function fulfillRandomness(bytes32 requestId, uint256 randomness) internal override {
        randomResult = randomness;
    }

    // function withdrawLink() external {} - Implement a withdraw function to avoid locking your LINK in the contract
}

/// @title ERC1155 ownerOf() for SpaceMiners portals contract
interface Portal {
    function ownerOf(uint256 tokenId) external view returns (address);
}

/// @title ERC20 (Gems.sol) minting function for player's rewards
interface Gem {
    function mintGems(address _player, uint amount) external;
    function balanceOf(address account) external view returns (uint256);
}

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

/// @title SpaceMiners contract for miners
contract SpaceMiners is ERC1155, RandomNumberConsumer {

    event Warp(address indexed _owner, uint _minerId, uint _activeMinerCount);
    event FeePayout(address indexed _minerOwner, address indexed _portalOwner, uint amount);

    struct Miner {
        uint bagSize;
        uint warpFee;
        uint returnTime;
        uint fee;
    }


    Miner[] public miners;
    mapping(address => mapping(uint => uint)) private activeMiners;
    mapping(address => mapping(uint => mapping(uint => uint))) private minersDepartedTime;
    mapping(address => mapping(uint => uint)) private departedCount;
    mapping(address => mapping(uint => uint)) private payoutCount;

    uint256 public constant MINER_1 = 0;
    uint256 public constant MINER_2 = 1;
    uint256 public constant MINER_3 = 2;
    uint256 public constant MINER_4 = 3;

    constructor() ERC1155("https://game.example/api/item/") {
        miners.push(Miner({bagSize: 16, warpFee: 5, returnTime: 48, fee: 1 ether}));
        miners.push(Miner({bagSize: 24, warpFee: 4, returnTime: 39, fee: 1 ether}));
        miners.push(Miner({bagSize: 32, warpFee: 4, returnTime: 31, fee: 1 ether}));
        // returnTime set to 0 for testing payout() function only
        miners.push(Miner({bagSize: 48, warpFee: 3, returnTime: 0, fee: 1 ether}));
    }

    /// @notice Mint miner for fee
    /// @param _minerId id of the miner (0-3)
    function mintMiner(uint _minerId) public payable {
        require(msg.value == miners[_minerId].fee);
        _mint(msg.sender, _minerId, 1, "");
    }

    /// @notice Checks owner of portal
    /// @param _id Portal id
    /// @param _portalContractAddress Portal contract address
    function checkPortalOwner(uint _id, address _portalContractAddress) internal view returns(address) {
        Portal portalsContract = Portal(_portalContractAddress);
        return portalsContract.ownerOf(_id);
    }

    /// @notice Mints GEMs to players account (can only be called by MINTER roles, check Gems.sol)
    /// @param _player Player's address for GEMs to be minted to
    /// @param _amount Amount of GEMs
    /// @param _gemContractAddress Address of ERC20 contract for GEMs
    function callMintGems(address _player, uint _amount, address _gemContractAddress) internal {
        Gem gemsContract = Gem(_gemContractAddress);
        gemsContract.mintGems(_player, _amount);
    }

    /// @notice Returns amount of active miner(s) for specified id
    /// @param _minerId id of the miner (0-3)
    function getActiveMiners(uint _minerId) public view returns(uint) {
        return activeMiners[msg.sender][_minerId];
    }

    /// @notice Send a miner through a random portal for GEMs
    /// @param _minerId id of the miner (0-3)
    function warp(uint _minerId) public {
        require(balanceOf(msg.sender, _minerId) - activeMiners[msg.sender][_minerId] >= 1, "You don't own any inactive miners");
        require(activeMiners[msg.sender][_minerId] <= 10, "Maximum of 10 miners warped per id");
        minersDepartedTime[msg.sender][_minerId][departedCount[msg.sender][_minerId]] = block.timestamp;
        activeMiners[msg.sender][_minerId]++;
        departedCount[msg.sender][_minerId]++;
        //getRandomNumber(); // Disabled unless running on Rinkeby and can load RandomNumberConsumer with LINK
    }

    /// @notice Payout to miner owner and portal owner if miner trip time has passed
    /// @param _minerId id of the miner (0-3)
    function payout(uint _minerId, address _gemContractAddress) public {
        uint counter;
        uint amount;
        for(uint i=0; i < activeMiners[msg.sender][_minerId]; i++) {
            if(minersDepartedTime[msg.sender][_minerId][payoutCount[msg.sender][_minerId]] - block.timestamp >= miners[_minerId].returnTime * 60) {
                amount += miners[_minerId].bagSize;
                payoutCount[msg.sender][_minerId]++;
                counter++;
            }
        }
        callMintGems(msg.sender, amount, _gemContractAddress);
        activeMiners[msg.sender][_minerId] -= counter;
    }

    function _beforeTokenTransfer(address operator, address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data) internal virtual override {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);

        for(uint i=0; i < ids.length; i++) {
            require(activeMiners[from][i] == 0, "Miner(s) still on the job");
        }
    }

}