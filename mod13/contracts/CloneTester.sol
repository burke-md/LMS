// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract CloneTester {
    address token;

    function setTestAddress(address _address) external {
        token = _address;
    }

    function callInitializer(uint256 _numTokens, string calldata _name, string calldata _symbol) external returns(bytes memory){
        (bool success, bytes memory data) = token.call(abi.encodeWithSignature("initialize(uint256,string,string,address)",
             _numTokens, _name, _symbol, msg.sender));
        return data;
    }

    function getName() external returns(bytes memory){
        (bool success, bytes memory data) = token.call(abi.encodeWithSignature("name()"));
        return data;
    }

    function getSymbol() external returns(bytes memory){
        (bool success, bytes memory data) = token.call(abi.encodeWithSignature("symbol()"));
        return data;
    }

    function getOwner() external returns(bytes memory){
        (bool success, bytes memory data) = token.call(abi.encodeWithSignature("owner()"));
        return data;
    }

    function getSupply() external returns(bytes memory){
        (bool success, bytes memory data) = token.call(abi.encodeWithSignature("totalSupply()"));
        return data;
    }
}