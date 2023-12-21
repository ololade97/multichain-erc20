// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./OFTCoreV2Initializable.sol";
import "./OFT/interfaces/IOFTV2.sol";
import "@openzeppelin/contracts-upgradeable/utils/introspection/ERC165Upgradeable.sol";

abstract contract BaseOFTV2Initializable is
    OFTCoreV2Initializable,
    ERC165Upgradeable,
    IOFTV2
{
    /************************************************************************
     * public functions
     ************************************************************************/
    function sendFrom(
        address _from,
        uint16 _dstChainId,
        bytes32 _toAddress,
        uint _amount,
        LzCallParams calldata _callParams
    ) public payable virtual override {
        _send(
            _from,
            _dstChainId,
            _toAddress,
            _amount,
            _callParams.refundAddress,
            _callParams.zroPaymentAddress,
            _callParams.adapterParams
        );
    }

    function sendAndCall(
        address _from,
        uint16 _dstChainId,
        bytes32 _toAddress,
        uint _amount,
        bytes calldata _payload,
        uint64 _dstGasForCall,
        LzCallParams calldata _callParams
    ) public payable virtual override {
        _sendAndCall(
            _from,
            _dstChainId,
            _toAddress,
            _amount,
            _payload,
            _dstGasForCall,
            _callParams.refundAddress,
            _callParams.zroPaymentAddress,
            _callParams.adapterParams
        );
    }

    /************************************************************************
     * public view functions
     ************************************************************************/
    function supportsInterface(
        bytes4 interfaceId
    )
        public
        view
        virtual
        override(ERC165Upgradeable, IERC165)
        returns (bool)
    {
        return
            interfaceId == type(IOFTV2).interfaceId ||
            super.supportsInterface(interfaceId);
    }

    function estimateSendFee(
        uint16 _dstChainId,
        bytes32 _toAddress,
        uint _amount,
        bool _useZro,
        bytes calldata _adapterParams
    ) public view virtual override returns (uint nativeFee, uint zroFee) {
        return
            _estimateSendFee(
                _dstChainId,
                _toAddress,
                _amount,
                _useZro,
                _adapterParams
            );
    }

    function estimateSendAndCallFee(
        uint16 _dstChainId,
        bytes32 _toAddress,
        uint _amount,
        bytes calldata _payload,
        uint64 _dstGasForCall,
        bool _useZro,
        bytes calldata _adapterParams
    ) public view virtual override returns (uint nativeFee, uint zroFee) {
        return
            _estimateSendAndCallFee(
                _dstChainId,
                _toAddress,
                _amount,
                _payload,
                _dstGasForCall,
                _useZro,
                _adapterParams
            );
    }

    function circulatingSupply() public view virtual override returns (uint);

    function token() public view virtual override returns (address);
}
