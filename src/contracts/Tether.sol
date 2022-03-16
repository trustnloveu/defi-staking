// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.7.0 < 0.9.0;

contract Tether {
    string  public name = "Fake Tether";
    string  public symbol = "FUSDT";
    uint256 public totalSupply = 1000000000000000000000000; // = 1,000,000.000000000000000000
    uint8   public decimals = 18;
  
    event Transfer(
        address indexed _from,
        address indexed _to, 
        uint _value
    );

    event Approval(
        address indexed _owner,
        address indexed _spender, 
        uint _value
    );

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    
    constructor() {
        balanceOf[msg.sender] = totalSupply;
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value); // require that the value is greater or equal for transfer
         
        balanceOf[msg.sender] -= _value; // transfer the amount and subtract the balance
        balanceOf[_to] += _value; // add the balance

        emit Transfer(msg.sender, _to, _value); // emit Event
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_value <= balanceOf[_from]);
        require(_value <= allowance[_from][msg.sender]);
        
        balanceOf[_to] += _value; // add the balance for transferFrom
        balanceOf[_from] -= _value; // subtract the balance for transferFrom

        allowance[msg.sender][_from] -= _value;

        emit Transfer(_from, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;


        emit Approval(msg.sender, _spender, _value);
        return true;
    }
}
