//Contract based on [https://docs.openzeppelin.com/contracts/3.x/erc721](https://docs.openzeppelin.com/contracts/3.x/erc721)
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./openzeppelin/contracts/utils/Counters.sol";
import "contracts/ERC721Tradable.sol";



contract Slice is ERC721Tradable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    uint initialPrice = 0.08 ether;
    uint MAX_SLICES = 628;
    address openSeaProxyRegistryAddress;

    constructor(address _openSeaProxyRegistryAddress) ERC721Tradable("MetaSlice", "SLICE", _openSeaProxyRegistryAddress) 
    {
        openSeaProxyRegistryAddress = _openSeaProxyRegistryAddress;
    }

    function mintSlices(uint _amount)
        external payable
        returns (uint256)
    {
        require(_tokenIds.current() + _amount <= MAX_SLICES, "All out of slices!");
        require(msg.value >= initialPrice * _amount, "Not enough eth!");
        
        for (uint i = 0; i < _amount; i++)
        {
            _tokenIds.increment();
            uint256 newItemId = _tokenIds.current();
            _safeMint(_msgSender(), newItemId);
        }
        return _tokenIds.current();
    }

    function withdrawAll() external onlyOwner
    {
        uint balance = address(this).balance;
        payable(_msgSender()).transfer(balance);
    }

    function reserveSlices() external onlyOwner
    {
        require(_tokenIds.current() + 10 <= MAX_SLICES, "All out of slices!");
        for (uint i = 0; i < 10; i++)
        {
            _tokenIds.increment();
            uint256 newItemId = _tokenIds.current();
            _safeMint(_msgSender(), newItemId);
        }
    }

    function contractURI() public pure returns (string memory)
    {
        return "https://www.testing.io/api/contract/";
    }

    function baseTokenURI() override public pure returns (string memory) {
        return "https://www.testing.io/api/slice/";
    }
}
