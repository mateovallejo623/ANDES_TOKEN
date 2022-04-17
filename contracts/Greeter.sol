// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;
import "./SafeMath.sol";
import "hardhat/console.sol";

interface IGreeter{
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function allowance(address owner,address spender) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint amount) external returns (bool);
    
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval (address indexed owner, address indexed spender, uint256 value);
}

contract Greeter is IGreeter {
    string public constant name = "ANDES";
    string public constant symbol = "ADS";
    uint8 public constant decimals = 5;
    
    event Transfer(address indexed from, address indexed to, uint256 tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
    
    mapping (address => uint) balances;
    mapping(address => mapping (address => uint)) allowed;
    uint256 totalSupply_;
    
    using SafeMath for uint256;
    
    constructor (uint256 total) public{
        totalSupply_ = total;
        balances[msg.sender] = totalSupply_;
    }
    
    function totalSupply() public override view returns (uint256){
        return totalSupply_;
    }
    
    function increaseTotalSuply(uint newTokens) public{
        totalSupply_ += newTokens;
        balances[msg.sender] += newTokens;
    }
    
    function balanceOf(address tokenOwner) public override view returns (uint256){
        return balances[tokenOwner];
    }
    
    function transfer(address receiver, uint256 numTokens) public override returns (bool){
        require(numTokens <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender].sub(numTokens);
        balances[receiver] = balances[receiver].add(numTokens);
        emit Transfer(msg.sender,receiver,numTokens);
        return true;
    } 
    
    function approve(address delegate, uint256 numTokens) public override returns (bool) {
        allowed[msg.sender][delegate] = numTokens;
        emit Approval(msg.sender, delegate, numTokens);
        return true;
    }
    
    function allowance(address owner, address delegate) public override view returns (uint){
        return allowed[owner][delegate];
    }
    
    function transferFrom(address owner, address buyer, uint256 numTokens) public override returns (bool){
        require (numTokens <= balances[owner]);
        require (numTokens <= allowed[owner][msg.sender]);
        
        balances[owner] = balances[owner].sub(numTokens);
        allowed[owner][msg.sender] = allowed[owner][msg.sender].sub(numTokens);
        balances[buyer] = balances[buyer].add(numTokens);
        emit Transfer(owner,buyer,numTokens);
        return true;
    }
}