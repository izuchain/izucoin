// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// NOTE: Import IERC20 contract
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

// NOTE: You must to implement IERC20 for override ERC20 methods!
contract IZUCoin is IERC20 {
  string public constant name = "IZU Coin";
  string public constant symbol = "IZUC";
  uint8 public constant decimals = 18;
  uint256 totalSupply_ = 10000000000000000000000000; 

  mapping(address => uint256) public balances;
  mapping(address => mapping (address => uint256)) allowed;

  // NOTE: I removed the events because it already defined into IERC20
  
  constructor() { 
    balances[msg.sender] = totalSupply_;
  }

  function totalSupply() public override view returns (uint256) {
    return totalSupply_;
  }

  // NOTE: You must to change signature function adding address parameter
  function balanceOf(address _address) public override view returns(uint256) {
    return balances[_address];
  }

  function transfer(address to, uint256 value) public override returns (bool) {
      require(value <= balances[msg.sender]);
      balances[msg.sender] = balances[msg.sender]-value;
      balances[to] = balances[to]+value;
      // NOTE: The event is called  Transfer not 'transfer'
      emit Transfer(msg.sender, to, value);
      return true;
  }

  function approve(address spender, uint256 value) public override returns (bool) {
      allowed[msg.sender][spender] = value;
      emit Approval(msg.sender, spender, value);
      return true;
  }

  function allowance(address owner, address spender) public override view returns (uint) {
      return allowed[owner][spender];
  }

  function transferFrom(address from, address to, uint256 value) public override returns (bool) {
      require(value <= balances[from]);
      require(value <= allowed[from][msg.sender]);

      balances[from] = balances[from]-value;
      allowed[from][msg.sender] = allowed[from][msg.sender]+value;
      balances[to] = balances[to]+value;
      emit Transfer(from, to, value);
      return true;
  }
}