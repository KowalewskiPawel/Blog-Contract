// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./libraries/IterableMapping.sol";

contract Blog is ERC721URIStorage {
    string[] private postsArray;

    using Counters for Counters.Counter;
    using IterableMapping for IterableMapping.Map;

    Counters.Counter private _tokenIds;
    Counters.Counter private _postsIds;

    IterableMapping.Map private posts;

    constructor() ERC721("Web3 Devs Poland", "W3PL") {
        mintNFT((msg.sender), "");
    }

    modifier isPrivileged() {
        require(balanceOf(msg.sender) == 1, "Not privileged");
        _;
    }

    function mintNFT(address user, string memory tokenURI)
        public
        isPrivileged
        returns (uint256)
    {
        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _mint(user, newItemId);
        _setTokenURI(newItemId, tokenURI);

        return newItemId;
    }

    function addPost(string memory _post) public isPrivileged {
        posts.set(_postsIds.current(), _post);
        postsArray.push(posts.get(_postsIds.current()));
        _postsIds.increment();
    }

    function getPosts() public view returns (string[] memory) {
        return postsArray;
    }

    function isNFTHolder() public view returns (bool) {
        if (balanceOf(msg.sender) > 0) {
            return true;
        }
        return false;
    }
}
