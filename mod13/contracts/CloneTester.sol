// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract CloneTester {
    address token;

    function setTestAddress(address _address) external {
        token = _address;
    }

    function setInitializer() external returns(bytes memory){
        (bool success, bytes memory data) = token.call(abi.encodeWithSignature("initialize()"));
        return data;
    }

    function getName() external returns(bytes memory){
        (bool success, bytes memory data) = token.call(abi.encodeWithSignature("name()"));
        return data;
    }

    function getTicker() external returns(bytes memory){
        (bool success, bytes memory data) = token.call(abi.encodeWithSignature("symbol()"));
        return data;
    }

    function getOwner() external returns(bytes memory){
        (bool success, bytes memory data) = token.call(abi.encodeWithSignature("owner()"));
        return data;
    }

    function getSupply() external returns(bytes memory){
        (bool success, bytes memory data) = token.call(abi.encodeWithSignature("totalSupply())"));
        return data;
    }

    function testAddFive(uint256 _num) external returns(bytes memory) {
        (bool success, bytes memory data) = token.call(abi.encodeWithSignature("addFive(uint256)", _num));
        return data;
    }

    function getSlotZeroZ() external returns(bytes memory) {
        (bool success, bytes memory data) = token.call(abi.encodeWithSignature("slotZero()"));
        return data;
    }
}