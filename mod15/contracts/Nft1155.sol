// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

// import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract Nft1155 is ERC1155 {
    address public immutable wrapperContract;

    constructor(address _wrapperContract) ERC1155("") {
        wrapperContract = _wrapperContract;
    }

    modifier onlyWrapper() {
        require(
            msg.sender == wrapperContract,
            "Function can only be called from wrapper contact"
        );
        _;
    }

    function setURI(string memory newuri) public onlyWrapper {
        _setURI(newuri);
    }

    function wrapperMint(address _user, uint256 _id) external onlyWrapper {
        _mint(_user, _id, 0x01, "");
    }

    function wrapperBurn(address _user, uint256 _id) external onlyWrapper {
        // Check made in wrapper contract prevents from burning arbitrary tokens
        _burn(_user, _id, 1);
    }
}
