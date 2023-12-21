// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.6.0;

import "../contracts/Kwenta.sol";

contract $Kwenta is Kwenta {
    constructor(string memory name, string memory symbol, uint256 _initialSupply, address _owner, address _initialHolder) Kwenta(name, symbol, _initialSupply, _owner, _initialHolder) {}

    function $_transfer(address sender,address recipient,uint256 amount) external {
        return super._transfer(sender,recipient,amount);
    }

    function $_mint(address account,uint256 amount) external {
        return super._mint(account,amount);
    }

    function $_burn(address account,uint256 amount) external {
        return super._burn(account,amount);
    }

    function $_approve(address owner,address spender,uint256 amount) external {
        return super._approve(owner,spender,amount);
    }

    function $_beforeTokenTransfer(address from,address to,uint256 amount) external {
        return super._beforeTokenTransfer(from,to,amount);
    }

    function $_afterTokenTransfer(address from,address to,uint256 amount) external {
        return super._afterTokenTransfer(from,to,amount);
    }

    function $_msgSender() external view returns (address) {
        return super._msgSender();
    }

    function $_msgData() external view returns (bytes memory) {
        return super._msgData();
    }
}
