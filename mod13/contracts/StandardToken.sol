// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

contract StandardToken is Initializable, ERC20Upgradeable, OwnableUpgradeable, UUPSUpgradeable {
    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize() initializer public {
        __ERC20_init("StandardToken", "STD");
        __Ownable_init();
        __UUPSUpgradeable_init();

        _mint(msg.sender, 50_000 * 10 ** decimals());
    }

    function _authorizeUpgrade(address newImplementation)
        internal
        onlyOwner
        override
    {}

    function addFive(uint256 _num) external pure returns(uint256) {
        return _num + 5;
    }

    function slotZero() external view returns(bytes memory) {
        bytes memory slotZero;
           assembly {
            slotZero := sload(0x00)
        }
        return slotZero;
    }
}
