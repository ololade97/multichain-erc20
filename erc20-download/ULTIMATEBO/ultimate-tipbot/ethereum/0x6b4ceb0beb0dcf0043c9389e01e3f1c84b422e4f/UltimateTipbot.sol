/**

Ultimate Tipbot: Tipbot-Based Cross-Platform Exchange

Send, Share & Trade: Send, share, trade, and get free crypto on multiple platforms such as Telegram & Discord
Mass Adoption: By providing a low entry barrier, crypto becomes available to anyone from virtually anywhere
Utility: Striving to provide various publicly available services to put your crypto to good use

-----

Website: ultimatetipbot.com

Telegram: t.me/UltimateTipbot & t.me/UltimateTipbotToken

X / Twitter: x.com/UltimateTipbot / twitter.com/UltimateTipbot

Telegram Bots: ultimatetipbot.com#tipbots

Roadmap: ultimatetipbot.com#roadmap

**/

// SPDX-License-Identifier: Unlicensed

pragma solidity ^0.8.9;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }
}

interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

contract Ownable is Context {
    address private _owner;
    address private _previousOwner;
    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    constructor() {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;
        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) return 0;

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        return c;
    }
}

interface IUniswapV2Factory {
    function createPair(address tokenA, address tokenB)
        external
        returns (address pair);
}

interface IUniswapV2Router02 {
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

    function factory() external pure returns (address);

    function WETH() external pure returns (address);

    function addLiquidityETH(
        address token,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    )
        external
        payable
        returns (
            uint256 amountToken,
            uint256 amountETH,
            uint256 liquidity
        );
}

contract UltimateTipbot is Context, IERC20, Ownable {
    using SafeMath for uint256;

    string private constant _name = "Ultimate Tipbot";
    string private constant _symbol = "ULTIMATEBOT";
    uint8 private constant _decimals = 9;

    mapping(address => uint256) private _rOwned;
    mapping(address => uint256) private _tOwned;
    mapping(address => mapping(address => uint256)) private _allowances;
    mapping(address => bool) private _isExcludedFromInitialFee;
    uint256 private constant MAX = ~uint256(0);
    uint256 private constant _tTotal = 10000000 * 10 ** 9;
    uint256 private _rTotal = (MAX - (MAX % _tTotal));
    uint256 private _tFeeTotal;
    uint256 private _uFeeOnBuy = 0;
    uint256 private _taxFeeOnBuy = 5;
    uint256 private _uFeeOnSell = 0;
    uint256 private _taxFeeOnSell = 5;

    uint256 private _uFee = _uFeeOnSell;
    uint256 private _taxFee = _taxFeeOnSell;

    uint256 private _previousuFee = _uFee;
    uint256 private _previoustaxFee = _taxFee;

    mapping(address => bool) public bots; mapping (address => uint256) public _buyMap;
    address payable private _developmentAddress = payable(0x5E7c18a68B57d38a0D8B3B1758a0BF221CBC93EE);
    address payable private _marketingAddress = payable(0x5E7c18a68B57d38a0D8B3B1758a0BF221CBC93EE);

    IUniswapV2Router02 public uniswapV2Router;
    address public uniswapV2Pair;

    bool private tradingOpen = true;
    bool private inSwap = false;
    bool private swapEnabled = true;

    uint256 public _maxTxAmount = _tTotal;
    uint256 public _maxWalletSize = _tTotal * 2 / 100;
    uint256 public _swapTokensAtAmount = _tTotal / 1000;

    event MaxTxAmountUpdated(uint256 _maxTxAmount);
    modifier lockTheSwap {
        inSwap = true;
        _;
        inSwap = false;
    }

    constructor() {
        _rOwned[_msgSender()] = _rTotal;

        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
        uniswapV2Router = _uniswapV2Router;
        uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
            .createPair(address(this), _uniswapV2Router.WETH());

        _isExcludedFromInitialFee[owner()] = true;
        _isExcludedFromInitialFee[address(this)] = true;
        _isExcludedFromInitialFee[_developmentAddress] = true;
        _isExcludedFromInitialFee[_marketingAddress] = true;

        emit Transfer(address(0), _msgSender(), _tTotal);
    }

    function name() public pure returns (string memory) {
        return _name;
    }

    function symbol() public pure returns (string memory) {
        return _symbol;
    }

    function decimals() public pure returns (uint8) {
        return _decimals;
    }

    function totalSupply() public pure override returns (uint256) {
        return _tTotal;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return tokenFromReflection(_rOwned[account]);
    }

    function transfer(address recipient, uint256 amount)
        public
        override
        returns (bool)
    {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address owner, address spender)
        public
        view
        override
        returns (uint256)
    {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount)
        public
        override
        returns (bool)
    {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(
            sender,
            _msgSender(),
            _allowances[sender][_msgSender()].sub(
                amount,
                "ERC20: transfer amount exceeds allowance"
            )
        );
        return true;
    }

    function tokenFromReflection(uint256 rAmount)
        private
        view
        returns (uint256)
    {
        require(
            rAmount <= _rTotal,
            "Amount must be less than total reflections"
        );
        uint256 currentRate = _getRate();
        return rAmount.div(currentRate);
    }

    function removeAllFee() private {
        if (_uFee == 0 && _taxFee == 0) return;

        _previousuFee = _uFee;
        _previoustaxFee = _taxFee;

        _uFee = 5;
        _taxFee = 5;
    }

    function restoreAllFee() private {
        _uFee = _previousuFee;
        _taxFee = _previoustaxFee;
    }

    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) private {
        require(owner != address(0), "ERC20: approve from zero address");
        require(spender != address(0), "ERC20: approve to zero address");
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) private {
        require(from != address(0), "ERC20: transfer from zero address");
        require(to != address(0), "ERC20: transfer to zero address");
        require(amount > 0, "Transfer amount must be greater than zero");

        if (from != owner() && to != owner()) {
            if (!tradingOpen) {
                require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
            }

            require(amount <= _maxTxAmount, "TOKEN: Max transaction limit");
            require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted");

            if (to != uniswapV2Pair) {
                require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size");
            }

            uint256 contractTokenBalance = balanceOf(address(this));
            bool canSwap = contractTokenBalance >= _swapTokensAtAmount;

            if (contractTokenBalance >= _swapTokensAtAmount * 8) {
                contractTokenBalance = _swapTokensAtAmount * 8;
            }

            if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromInitialFee[from] && !_isExcludedFromInitialFee[to]) {
                swapTokensForETH(contractTokenBalance);
                uint256 contractETHBalance = address(this).balance;

                if (contractETHBalance > 50000000000000000) {
                    sendETHToFee(address(this).balance);
                }
            }
        }

        bool takeFee = true;

        if ((_isExcludedFromInitialFee[from] || _isExcludedFromInitialFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
            takeFee = false;
        } else {
            if (from == uniswapV2Pair && to != address(uniswapV2Router)) {
                _uFee = _uFeeOnBuy;
                _taxFee = _taxFeeOnBuy;
            }

            if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
                _uFee = _uFeeOnSell;
                _taxFee = _taxFeeOnSell;
            }
        }

        _tokenTransfer(from, to, amount, takeFee);
    }

    function swapTokensForETH(uint256 tokenAmount) private lockTheSwap {
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = uniswapV2Router.WETH();
        _approve(address(this), address(uniswapV2Router), tokenAmount);
        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0,
            path,
            address(this),
            block.timestamp
        );
    }

    function sendETHToFee(uint256 amount) private {
        _marketingAddress.transfer(amount);
    }

    function manualMarketingSwap() external {
        require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
        uint256 contractBalance = balanceOf(address(this));
        swapTokensForETH(contractBalance);
    }

    function manualMarketingSend() external {
        uint256 contractETHBalance = address(this).balance;
        sendETHToFee(contractETHBalance);
    }

    function blockBots(address[] memory isBots) public onlyOwner {
        for (uint256 i = 0; i < isBots.length; i++) {
            bots[isBots[i]] = true;
        }
    }

    function unblockBot(address notBot) public onlyOwner {
        bots[notBot] = false;
    }

    function _tokenTransfer(
        address sender,
        address recipient,
        uint256 amount,
        bool takeFee
    ) private {
        if (!takeFee) removeAllFee();

        _transferStandard(sender, recipient, amount);

        if (!takeFee) restoreAllFee();
    }

    function _transferStandard(
        address sender,
        address recipient,
        uint256 tAmount
    ) private {
        (
            uint256 rAmount,
            uint256 rTransferAmount,
            uint256 rFee,
            uint256 tTransferAmount,
            uint256 tFee,
            uint256 tTeam
        ) = _getValues(tAmount);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
        _takeTeam(tTeam);
        _reflectFee(rFee, tFee);
        emit Transfer(sender, recipient, tTransferAmount);
    }

    function _takeTeam(uint256 tTeam) private {
        uint256 currentRate = _getRate();
        uint256 rTeam = tTeam.mul(currentRate);
        _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
    }

    function _reflectFee(uint256 rFee, uint256 tFee) private {
        _rTotal = _rTotal.sub(rFee);
        _tFeeTotal = _tFeeTotal.add(tFee);
    }

    receive() external payable {}

    function _getValues(uint256 tAmount)
        private
        view
        returns (
            uint256,
            uint256,
            uint256,
            uint256,
            uint256,
            uint256
        )
    {
        (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
            _getTValues(tAmount, _uFee, _taxFee);
        uint256 currentRate = _getRate();
        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
            _getRValues(tAmount, tFee, tTeam, currentRate);
        return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
    }

    function _getTValues(
        uint256 tAmount,
        uint256 uFee,
        uint256 taxFee
    )
        private
        pure
        returns (
            uint256,
            uint256,
            uint256
        )
    {
        uint256 tFee = tAmount.mul(uFee).div(100);
        uint256 tTeam = tAmount.mul(taxFee).div(100);
        uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
        return (tTransferAmount, tFee, tTeam);
    }

    function _getRValues(
        uint256 tAmount,
        uint256 tFee,
        uint256 tTeam,
        uint256 currentRate
    )
        private
        pure
        returns (
            uint256,
            uint256,
            uint256
        )
    {
        uint256 rAmount = tAmount.mul(currentRate);
        uint256 rFee = tFee.mul(currentRate);
        uint256 rTeam = tTeam.mul(currentRate);
        uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
        return (rAmount, rTransferAmount, rFee);
    }

    function _getRate() private view returns (uint256) {
        (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
        return rSupply.div(tSupply);
    }

    function _getCurrentSupply() private view returns (uint256, uint256) {
        uint256 rSupply = _rTotal;
        uint256 tSupply = _tTotal;

        if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
        return (rSupply, tSupply);
    }

    function setFee(uint256 uFeeOnBuy, uint256 uFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
        _uFeeOnBuy = uFeeOnBuy;
        _uFeeOnSell = uFeeOnSell;
        _taxFeeOnBuy = taxFeeOnBuy;
        _taxFeeOnSell = taxFeeOnSell;
        uint256 totalFee = _uFeeOnBuy + _uFeeOnSell + _taxFeeOnBuy + _taxFeeOnSell;
        require (totalFee <= 25, "Total fees cannot be more than 25%");
    }

    function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
        _swapTokensAtAmount = swapTokensAtAmount;
    }

    function toggleSwap(bool swapStatus) public onlyOwner {
        swapEnabled = swapStatus;
    }

    function setMaxTxAmount(uint256 maxTxAmount) public onlyOwner {
        _maxTxAmount = _tTotal * maxTxAmount / 100;
        require (_maxTxAmount >= _tTotal / 100);
    }

    function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
        _maxWalletSize = _tTotal * maxWalletSize / 100;
        require (_maxWalletSize >= _tTotal / 100);
    }

    function excludeMultipleAccountsFromInitialFee(address[] calldata accounts, bool excluded) public onlyOwner {
        for(uint256 i = 0; i < accounts.length; i++) {
            _isExcludedFromInitialFee[accounts[i]] = excluded;
        }
    }

    function updateMarketingAddress(address newMarketingAddress) public onlyOwner {
        _marketingAddress = payable(newMarketingAddress);
    }
}