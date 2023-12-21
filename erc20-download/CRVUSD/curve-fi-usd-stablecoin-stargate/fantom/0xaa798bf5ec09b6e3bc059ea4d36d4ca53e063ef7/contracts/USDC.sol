// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@layerzerolabs/solidity-examples/contracts/token/oft/v2/OFTV2.sol";

contract USDC is OFTV2 {
    constructor(address _layerZeroEndpoint) OFTV2("USD Coin", "USDC", 6, _layerZeroEndpoint) {}

    function decimals() public view virtual override returns (uint8) {
        return 6;
    }
}
