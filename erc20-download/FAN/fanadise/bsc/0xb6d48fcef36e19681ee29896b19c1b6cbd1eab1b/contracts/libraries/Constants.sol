// SPDX-License-Identifier: MIT

pragma solidity 0.8.6;

library Constants {
    string private constant _name = "Fanadise";
    string private constant _symbol = "FAN";
    uint8 private constant _decimals = 18;

    function getName() internal pure returns (string memory) {
        return _name;
    }

    function getSymbol() internal pure returns (string memory) {
        return _symbol;
    }

    function getDecimals() internal pure returns (uint8) {
        return _decimals;
    }
}
