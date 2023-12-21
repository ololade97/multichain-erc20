// SPDX-License-Identifier: MIT

pragma solidity ^0.8.5;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract SwapHelper is Ownable {
  constructor() {}

  function safeApprove(address token, address spender, uint256 amount) external onlyOwner { ERC20(token).approve(spender, amount); }

  function safeWithdraw() external onlyOwner { payable(_msgSender()).transfer(address(this).balance); }
}