pragma solidity ^0.8.1;
// SPDX-License-Identifier: UNLICENSED
interface IPancakeswapFactory {
  function createPair(address tokenA, address tokenB) external returns (address pair);
}

interface IPancakeswapRouter {
  function WETH() external pure returns (address);
  function factory() external view returns (address);
  function swapExactTokensForETHSupportingFeeOnTransferTokens(
    uint amountIn,
    uint amountOutMin,
    address[] calldata path,
    address to,
    uint deadline
  ) external;
  function addLiquidityETH(
    address token,
    uint amountTokenDesired,
    uint amountTokenMin,
    uint amountETHMin,
    address to,
    uint deadline
  ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
}
