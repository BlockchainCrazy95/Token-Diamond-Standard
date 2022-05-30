// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { AppStorage } from "../libraries/LibAppStorage.sol";
import {LibERC20} from "../libraries/LibERC20.sol";
import { LibDiamond } from "../libraries/LibDiamond.sol";

contract MockCoinFacet{

    AppStorage internal s;
    LibDiamond.DiamondStorage ds;
    
    uint256 public constant maxTotalSupply = 10 ** 12 * 10 ** 18;
    uint256 constant MAX_UINT = type(uint256).max;

    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    function name() external pure returns (string memory) {
        return "MockCoin";
    }

    function symbol() external pure returns (string memory) {
        return "MOCKCOIN";
    }

    function decimals() external pure returns (uint8) {
        return 18;
    }

    function totalSupply() public view returns (uint256) {
        return s.totalSupply;
    }

    function balanceOf(address _owner) public view returns (uint256 balance) {
        balance = s.balances[_owner];
    }

    function transfer(address _to, uint256 _value) public returns(bool success) {
        LibERC20.transfer(s, msg.sender, _to, _value);
        success = true;
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public returns (bool success) {
        LibERC20.transfer(s, _from, _to, _value);
        uint256 currentAllowance = s.allowances[_from][msg.sender];
        require(currentAllowance >= _value, "transfer amount exceeds allowance");
        unchecked {
            LibERC20.approve(s, _from, msg.sender, currentAllowance - _value);        
        }
        success = true;
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        LibERC20.approve(s, msg.sender, _spender, _value);
        success = true;
    }

    function increaseAllowance(address _spender, uint256 _value) external returns (bool success) {
        unchecked {
            LibERC20.approve(s, msg.sender, _spender, s.allowances[msg.sender][_spender] + _value);
        }
        success = true;
    }

    function decreaseAllowance(address _spender, uint256 _value) external returns (bool success) {
        uint256 l_allowance = s.allowances[msg.sender][_spender];
        require(l_allowance >= _value, "TokenFacet: Allowance decreased below 0");
        l_allowance -= _value;
        s.allowances[msg.sender][_spender] = l_allowance;
        emit Approval(msg.sender, _spender, l_allowance);
        success = true;
    }

    function allowance(address _owner, address _spender) public view returns (uint256 remaining_) {
        remaining_ = s.allowances[_owner][_spender];
    }

}