// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts@4.7.3/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.7.3/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts@4.7.3/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts@4.7.3/access/Ownable.sol";
import "@openzeppelin/contracts@4.7.3/utils/Counters.sol";

contract CarbonCredit is ERC721, ERC721URIStorage, ERC721Burnable, Ownable {
    bool public saleIsActive = true;
    string private _baseURI;
    uint256 public immutable MAX_SUPPLY;
    uint256 public currentPrice;

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    constructor(string memory _name,
        string memory _symbol,
        string memory _uri,
        uint256 limit,
        uint256 price,
        uint256 maxSupply
    ) payable ERC721(_name, _symbol) {
        _baseURIextended = _uri;
        currentPrice = price;
        MAX_SUPPLY = maxSupply;
        }

    function mint(uint256 amount) external payable {
        uint256 ts = totalSupply();
        uint256 minted = _numberMinted(msg.sender);

        require(saleIsActive, "Sale must be active to mint tokens");
        require(ts + amount <= MAX_SUPPLY, "Purchase would exceed max tokens");
        require(
            currentPrice * amount == msg.value,
            "Value sent is not correct"
        );

        _safeMint(msg.sender, amount);
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
}
