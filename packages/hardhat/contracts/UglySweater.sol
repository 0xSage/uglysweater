pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

import "@nibbstack/erc721/src/contracts/tokens/nf-token-metadata.sol";
import "@nibbstack/erc721/src/contracts/tokens/nf-token-enumerable.sol";
import "@nibbstack/erc721/src/contracts/ownership/ownable.sol";

// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol

contract UglySweater is NFTokenMetadata, NFTokenEnumerable, Ownable {
    constructor() {
        nftName = "Ugly Sweater";
        nftSymbol = "UGLY";
    }

    // to support receiving ETH by default
    receive() external payable {}

    fallback() external payable {}

    /**
     * @dev Returns the balance of the contract.
     */
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    /**
     * @dev Allows contract Owner to withdraw all the funds.
     */
    function withdrawFunds() external onlyOwner {
        payable(owner).transfer(address(this).balance);
    }

    /**
     * @dev Mints a new NFT.
     * @notice This is an external function which can be called by any user.
     * @param _to The address that will own the minted NFT.
     * @param _tokenId of the NFT to be minted by the msg.sender.
     * @param _uri String representing RFC 3986 URI.
     */
    function mint(
        address _to,
        uint256 _tokenId,
        string calldata _uri
    ) external payable {
        // TODO: check that some fee is paid, tricky to fix it at $1 though...
        super._mint(_to, _tokenId);
        // obviously not secure, but good enough for demo
        super._setTokenUri(_tokenId, _uri);
    }

    /**
     * @dev Burns a NFT.
     * @param _tokenId ID of the NFT to be burned.
     */
    function burn(uint256 _tokenId) external onlyOwner {
        super._burn(_tokenId);
    }

    /**
     * @dev Mints a new NFT.
     * @notice This is an internal function which should be called from user-implemented external
     * mint function. Its purpose is to show and properly initialize data structures when using this
     * implementation.
     * @param _to The address that will own the minted NFT.
     * @param _tokenId of the NFT to be minted by the msg.sender.
     */
    function _mint(
        address _to,
        uint256 _tokenId
    ) internal virtual override(NFToken, NFTokenEnumerable) {
        NFTokenEnumerable._mint(_to, _tokenId);
    }

    /**
     * @dev Burns a NFT.
     * @notice This is an internal function which should be called from user-implemented external
     * burn function. Its purpose is to show and properly initialize data structures when using this
     * implementation. Also, note that this burn implementation allows the minter to re-mint a burned
     * NFT.
     * @param _tokenId ID of the NFT to be burned.
     */
    function _burn(
        uint256 _tokenId
    ) internal virtual override(NFTokenMetadata, NFTokenEnumerable) {
        NFTokenEnumerable._burn(_tokenId);
        if (bytes(idToUri[_tokenId]).length != 0) {
            delete idToUri[_tokenId];
        }
    }

    /**
     * @notice Use and override this function with caution. Wrong usage can have serious consequences.
     * @dev Removes a NFT from an address.
     * @param _from Address from wich we want to remove the NFT.
     * @param _tokenId Which NFT we want to remove.
     */
    function _removeNFToken(
        address _from,
        uint256 _tokenId
    ) internal override(NFToken, NFTokenEnumerable) {
        NFTokenEnumerable._removeNFToken(_from, _tokenId);
    }

    /**
     * @notice Use and override this function with caution. Wrong usage can have serious consequences.
     * @dev Assigns a new NFT to an address.
     * @param _to Address to wich we want to add the NFT.
     * @param _tokenId Which NFT we want to add.
     */
    function _addNFToken(
        address _to,
        uint256 _tokenId
    ) internal override(NFToken, NFTokenEnumerable) {
        NFTokenEnumerable._addNFToken(_to, _tokenId);
    }

    /**
     * @dev Helper function that gets NFT count of owner. This is needed for overriding in enumerable
     * extension to remove double storage(gas optimization) of owner nft count.
     * @param _owner Address for whom to query the count.
     * @return Number of _owner NFTs.
     */
    function _getOwnerNFTCount(
        address _owner
    ) internal view override(NFToken, NFTokenEnumerable) returns (uint256) {
        return NFTokenEnumerable._getOwnerNFTCount(_owner);
    }
}

// contract YourContract {

//   event SetPurpose(address sender, string purpose);

//   string public purpose = "Building Unstoppable Apps!!!";

//   constructor() payable {
//     // what should we do on deploy?
//   }

//   function setPurpose(string memory newPurpose) public payable {
//       purpose = newPurpose;
//       console.log(msg.sender,"set purpose to",purpose);
//       emit SetPurpose(msg.sender, purpose);
//   }

//   // to support receiving ETH by default
//   receive() external payable {}
//   fallback() external payable {}
// }
