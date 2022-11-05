// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Paramo is ERC721, ERC721Enumerable, ERC721URIStorage, ERC721Burnable, Ownable {
    bool public saleIsActive = true;
    string private _baseURIextended;
    uint256 public immutable MAX_SUPPLY;
    uint256 public currentPrice;

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    constructor(string memory _name,
        string memory _symbol,
        string memory _uri,
        uint256 price,
        uint256 maxSupply
    ) payable ERC721(_name, _symbol) {
        _baseURIextended = _uri; 
        currentPrice = price;
        MAX_SUPPLY = maxSupply;
        }

    function mint(uint256 amount) external payable {
        uint256 ts = totalSupply();
        uint256 tokenId = _tokenIdCounter.current();

        require(saleIsActive, "Sale must be active to mint tokens");
        require(ts + amount <= MAX_SUPPLY, "Purchase would exceed max tokens");
        require(currentPrice * amount == msg.value,"Value sent is not correct");
        for(uint i = 0; i < amount; ++i){
        tokenId = _tokenIdCounter.current();
        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, _baseURIextended);
        _tokenIdCounter.increment();
        }
    }

    // The following functions are overrides required by Solidity.

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function updateURI(uint256 _tokenId, string memory uri) public onlyOwner{
        _setTokenURI(_tokenId, uri);
    }

    function withdraw() external onlyOwner {
        uint256 balance = address(this).balance;
        payable(msg.sender).transfer(balance);
    }

    function setSaleIsActive(bool isActive) external onlyOwner {
        saleIsActive = isActive;
    }

    function setCurrentPrice(uint256 price) external onlyOwner {
        currentPrice = price;
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}

