//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AppStorage} from "../libraries/LibAppStorage.sol";
import {LibERC20} from "../libraries/LibERC20.sol";
import {LibDiamond} from "../libraries/LibDiamond.sol";

contract MintBurnFacet {
    AppStorage s;

    function mint(address _receiver, uint256 _value) external {
        LibDiamond.enforceIsContractOwner();
        require(_receiver != address(0), "_to cannot be zero address");        
        s.balances[_receiver] += _value;
        s.totalSupply += _value;            
        emit LibERC20.Transfer(address(0), _receiver, _value);       
    }

    function burn(address _account, uint256 _amount) external {
        LibDiamond.enforceIsContractOwner();
        uint256 accountBalance = s.balances[_account];
        require(accountBalance >= _amount, "TokenFacet: burn amount exceeds balance");
        s.balances[_account] -= _amount;
        s.totalSupply -= _amount;
        emit LibERC20.Transfer(_account, address(0), _amount);
    }
}