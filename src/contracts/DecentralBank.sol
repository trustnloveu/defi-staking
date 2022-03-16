// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.7.0 < 0.9.0;

import './RWD.sol';
import './Tether.sol';

contract DecentralBank {
    string public name = 'Decentral Bank';
    address public owner;
    Tether public tether;
    RWD public rwd;

    address[] public stakers;

    mapping(address => uint) public stakingBalance;
    mapping(address => bool) public hasStaked;
    mapping(address => bool) public isStaking;

    constructor(RWD _rwd, Tether _tether) {
        rwd = _rwd;
        tether = _tether;
        owner = msg.sender;
    }

    // Stake
    function depositTokens(uint _amount) public {
        require(_amount > 0, 'amount cannot be 0');
        
        tether.transferFrom(msg.sender, address(this), _amount); // Transfer tether tokens to this contract address for staking
        stakingBalance[msg.sender] = stakingBalance[msg.sender] + _amount; // Update Staking Balance

        if(!hasStaked[msg.sender]) {
            stakers.push(msg.sender);
        }
        
        isStaking[msg.sender] = true;
        hasStaked[msg.sender] = true;
    }

    // Unstake
    function unstakeTokens() public {
        uint balance = stakingBalance[msg.sender];
        require(balance > 0, 'staking balance cannot be less than zero');

        tether.transfer(msg.sender, balance); // transfer the tokens to the specified contract address from our bank
        stakingBalance[msg.sender] = 0; // reset staking balance
        isStaking[msg.sender] = false; // Update Staking Status
    }

    // Issue Tokens
    function issueTokens() public {
        require(msg.sender == owner, 'caller must be the owner');

        // issue tokens to all stakers
        for (uint i=0; i<stakers.length; i++) {
            address recipient = stakers[i]; 
            uint balance = stakingBalance[recipient] / 9;

            if(balance > 0) {
                rwd.transfer(recipient, balance);
            }
       }
    }
}