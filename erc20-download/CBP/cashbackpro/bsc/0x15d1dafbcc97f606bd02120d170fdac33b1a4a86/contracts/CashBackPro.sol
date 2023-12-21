// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import "./libraries/SafeMath.sol";

contract CashBackPro {
    using SafeMath for uint256;
    uint256 public totalSupply;
    uint8 public decimals; //
    string public name; //
    string public symbol; //

    mapping(address => uint256) balances; //

    mapping(address => mapping(address => uint256)) allowed; //

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    constructor() {
        decimals = 6;
        name = "CashBackPro";
        symbol = "CBP";
        totalSupply = SafeMath.mul(102000000, 10**uint256(decimals));
        balances[msg.sender] = totalSupply;
        emit Transfer(address(0), msg.sender, totalSupply);
    }

    function transfer(address to, uint256 value) external returns (bool) {
        require(to != address(0), "to address error");
        require(balances[msg.sender] >= value, "lack of balance");
        balances[msg.sender] = balances[msg.sender].sub(value);
        balances[to] = balances[to].add(value);
        emit Transfer(msg.sender, to, value);
        return true;
    }

    function approve(address spender, uint256 value) external returns (bool) {
        allowed[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool) {
        require(allowed[from][msg.sender] >= value, "lack of allowed");
        require(balances[from] >= value, "lack of balance");
        balances[to] = balances[to].add(value);
        allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
        balances[from] = balances[from].sub(value);
        emit Transfer(from, to, value);
        return true;
    }

    function balanceOf(address who) external view returns (uint256) {
        return balances[who];
    }

    function allowance(address owner, address spender)
        external
        view
        returns (uint256)
    {
        return allowed[owner][spender];
    }
}
