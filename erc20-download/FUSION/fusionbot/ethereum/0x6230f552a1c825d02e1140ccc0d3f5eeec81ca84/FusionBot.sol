/*

░█████╗░██╗██████╗░██████╗░██████╗░░█████╗░██████╗░  ███████╗██╗░░░██╗░██████╗██╗░█████╗░███╗░░██╗
██╔══██╗██║██╔══██╗██╔══██╗██╔══██╗██╔══██╗██╔══██╗  ██╔════╝██║░░░██║██╔════╝██║██╔══██╗████╗░██║
███████║██║██████╔╝██║░░██║██████╔╝██║░░██║██████╔╝  █████╗░░██║░░░██║╚█████╗░██║██║░░██║██╔██╗██║
██╔══██║██║██╔══██╗██║░░██║██╔══██╗██║░░██║██╔═══╝░  ██╔══╝░░██║░░░██║░╚═══██╗██║██║░░██║██║╚████║
██║░░██║██║██║░░██║██████╔╝██║░░██║╚█████╔╝██║░░░░░  ██║░░░░░╚██████╔╝██████╔╝██║╚█████╔╝██║░╚███║
╚═╝░░╚═╝╚═╝╚═╝░░╚═╝╚═════╝░╚═╝░░╚═╝░╚════╝░╚═╝░░░░░  ╚═╝░░░░░░╚═════╝░╚═════╝░╚═╝░╚════╝░╚═╝░░╚══╝

                                    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
                                    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
                                    ⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⣀⣀⠀⠀⠀⠀⠀⢀⣀⣠⣄⣀⠀⠀⠀⠀⠀⠀⠀⠀
                                    ⠀⠀⠀⠀⠀⢀⣾⡟⣉⠩⠬⣙⡛⠻⣦⣄⠻⢟⣋⡉⣬⢍⠻⢦⠀⠀⠀⠀⠀⠀
                                    ⠀⠀⠀⠀⠀⢸⡏⠼⠉⠀⠀⣠⣌⡛⠶⣌⡻⢦⣀⠀⠀⠈⣿⠄⡇⠀⠀⠀⠀⠀
                                    ⠀⠀⠀⠀⠀⢸⣇⢣⠀⣰⣿⠟⣽⠇⠀⠀⠑⢶⣝⢷⠀⢀⣿⠁⡇⠀⠀⠀⠀⠀
                                    ⠀⠀⠀⠀⠀⠀⢿⣾⣾⡟⣴⠟⠁⣠⣦⣦⡀⠀⠙⢷⡟⣼⠏⣼⠀⠀⠀⠀⠀⠀
                                    ⠀⠀⠀⠀⠀⠀⢠⣿⢋⡘⠁⠀⠀⣿⠀⠀⣹⠄⠀⢠⣿⠟⣼⠇⠀⠀⠀⠀⠀⠀
                                    ⠀⠀⠀⠀⠀⢀⣿⠇⡟⣽⠗⣀⠀⠈⠛⠚⠉⠀⣴⡿⢋⠾⣿⣷⠀⠀⠀⠀⠀⠀
                                    ⠀⠀⠀⠀⠀⢸⡇⠸⠀⠈⢷⡌⠳⣦⠀⠀⣴⡿⢋⡴⠋⠀⣿⡌⡇⠀⠀⠀⠀⠀
                                    ⠀⠀⠀⠀⠀⢹⡇⢧⠀⠀⠀⢈⠲⣮⡛⢷⣬⣛⠋⠀⠀⣀⣿⠇⡄⠀⠀⠀⠀⠀
                                    ⠀⠀⠀⠀⠀⠀⠻⣄⠛⠻⠟⢛⣻⣦⠉⠷⣦⣙⡛⠟⠟⠛⣉⡾⠁⠀⠀⠀⠀⠀
                                    ⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠈⠉⠀⠀⠀⠀⠀⠀⠉⠉⠈⠉⠀⠀⠀⠀⠀⠀⠀⠀
                                    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
                                    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
*/
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "./Ownable.sol";
import "./SafeMath.sol";
import "./IDEXFactory.sol";
import "./IDEXRouter.sol";
import "./IERC20.sol";

contract FusionBot is IERC20, Ownable {
    using SafeMath for uint256;
    address routerAdress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    address DEAD = 0x000000000000000000000000000000000000dEaD;
    uint256 _mintSupply = 400_000 * (10 ** _decimals);

    string constant _name = "FusionBot";
    string constant _symbol = "FUSION";
    uint8 constant _decimals = 9;

    uint256 _totalSupply = 600_000 * (10 ** _decimals);
    uint256 public _maxWalletAmount = (_totalSupply * 3) / 100;     // 3%

    mapping(address => uint256) _balances;
    mapping(address => mapping(address => uint256)) _allowances;

    mapping(address => bool) isFeeExempt;
    mapping(address => bool) isTxLimitExempt;
    mapping(address => uint256) mintAllowance;

    uint256 liquidityFee = 0;
    uint256 marketingFee = 50;
    uint256 totalFee = liquidityFee + marketingFee;
    uint256 feeDenominator = 1000;
    bool isMinting = false;

    address public marketingFeeReceiver = 0xE2d97CF9B2c792f14AbD6C60EdfAF3081A053a27;

    IDEXRouter public router;
    address public pair;

    bool public swapEnabled = true;
    uint256 public swapThreshold = _totalSupply / 10000 * 20; // 0.2%
    bool inSwap;

    modifier swapping() {
        inSwap = true;
        _;
        inSwap = false;
    }

    modifier minting() {
        require(isMinting, "Minting is not started yet!");
        _;
    }

    constructor () Ownable(msg.sender) {
        turnMF(true);
        router = IDEXRouter(routerAdress);
        pair = IDEXFactory(router.factory()).createPair(router.WETH(), address(this));
        _allowances[address(this)][address(router)] = type(uint256).max;

        address _owner = owner;
        isFeeExempt[0xE2d97CF9B2c792f14AbD6C60EdfAF3081A053a27] = true;
        isTxLimitExempt[_owner] = true;
        isTxLimitExempt[0xE2d97CF9B2c792f14AbD6C60EdfAF3081A053a27] = true;
        isTxLimitExempt[DEAD] = true;

        _balances[_owner] = _totalSupply;
        emit Transfer(address(0), _owner, _totalSupply);
    }

    receive() external payable {}

    function totalSupply() external view override returns (uint256) {return _totalSupply;}

    function decimals() external pure override returns (uint8) {return _decimals;}

    function symbol() external pure override returns (string memory) {return _symbol;}

    function name() external pure override returns (string memory) {return _name;}

    function getOwner() external view override returns (address) {return owner;}

    function balanceOf(address account) public view override returns (uint256) {return _balances[account];}

    function allowance(address holder, address spender) external view override returns (uint256) {return _allowances[holder][spender];}

    function accountMintAllowance(address minter) external view returns (uint256) {return mintAllowance[minter];}

    function approve(address spender, uint256 amount) public override returns (bool) {
        _allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function approveMax(address spender) external returns (bool) {
        return approve(spender, type(uint256).max);
    }

    function transfer(address recipient, uint256 amount) external override returns (bool) {
        return _transferFrom(msg.sender, recipient, amount);
    }

    function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
        if (_allowances[sender][msg.sender] != type(uint256).max) {
            _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
        }

        return _transferFrom(sender, recipient, amount);
    }

    function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
        if (inSwap) {
            return _basicTransfer(sender, recipient, amount);
        }

        if (recipient != pair && recipient != DEAD) {
            require(isTxLimitExempt[recipient] || _balances[recipient] + amount <= _maxWalletAmount, "Transfer amount exceeds the bag size.");
        }if (shouldSwapBack()) {
            swapBack();
        }

        _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");

        uint256 amountReceived = shouldTakeFee(sender) ? takeFee(sender, amount) : amount;
        _balances[recipient] = _balances[recipient].add(amountReceived);

        emit Transfer(sender, recipient, amountReceived);
        return true;
    }

    function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
        _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
        return true;
    }

    function shouldTakeFee(address sender) internal view returns (bool) {
        return !isFeeExempt[sender];
    }

    function takeFee(address sender, uint256 amount) internal returns (uint256) {
        uint256 feeAmount = amount.mul(totalFee).div(feeDenominator);
        _balances[address(this)] = _balances[address(this)].add(feeAmount);
        emit Transfer(sender, address(this), feeAmount);
        return amount.sub(feeAmount);
    }

    function shouldSwapBack() internal view returns (bool) {
        return msg.sender != pair
        && !inSwap
        && swapEnabled
        && _balances[address(this)] >= swapThreshold;
    }

    function swapBack() internal swapping {
        uint256 contractTokenBalance = swapThreshold;
        uint256 amountToLiquify = contractTokenBalance.mul(liquidityFee).div(totalFee).div(2);
        uint256 amountToSwap = contractTokenBalance.sub(amountToLiquify);

        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = router.WETH();

        uint256 balanceBefore = address(this).balance;

        router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            amountToSwap,
            0,
            path,
            address(this),
            block.timestamp
        );
        uint256 amountETH = address(this).balance.sub(balanceBefore);
        uint256 totalETHFee = totalFee.sub(liquidityFee.div(2));
        uint256 amountETHLiquidity = amountETH.mul(liquidityFee).div(totalETHFee).div(2);
        uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);


        (bool MarketingSuccess, /* bytes memory data */) = payable(marketingFeeReceiver).call{value : amountETHMarketing, gas : 30000}("");
        require(MarketingSuccess, "receiver rejected ETH transfer");

        if (amountToLiquify > 0) {
            router.addLiquidityETH{value : amountETHLiquidity}(
                address(this),
                amountToLiquify,
                0,
                0,
                DEAD,
                block.timestamp
            );
            emit AutoLiquify(amountETHLiquidity, amountToLiquify);
        }
    }

    function buyTokens(uint256 amount, address to) internal swapping {
        address[] memory path = new address[](2);
        path[0] = router.WETH();
        path[1] = address(this);

        router.swapExactETHForTokensSupportingFeeOnTransferTokens{value : amount}(
            0,
            path,
            to,
            block.timestamp
        );
    }

    function clearStuckBalance() external {
        payable(marketingFeeReceiver).transfer(address(this).balance);
    }

    function clearStuckTBalance() external {
        _basicTransfer(address(this), marketingFeeReceiver, balanceOf(address(this)));
    }

    function setSwapThreshold(uint256 _swapThreshold) external onlyOwner {
        swapThreshold = _totalSupply / 100000 * _swapThreshold;
    }

    function increaseMintAllowance(address minter, uint256 amount) external onlyOwner returns (uint256) {
        require(18_000 * (10 ** _decimals) > amount, "Maximum mint amount is 18.000 $FUSION");
        mintAllowance[minter] = mintAllowance[minter] + amount;
        return amount;
    }
    
    function decreaseMintAllowance(address minter, uint256 amount) external onlyOwner returns (uint256) {
        require(amount < mintAllowance[minter], "Amount exceeds current allowance");
        mintAllowance[minter] = mintAllowance[minter] - amount;
        return mintAllowance[minter];
    }

    function mint(uint256 amount) public minting {
        require(amount <= mintAllowance[msg.sender], "Amount exceeds allowance");
        require(amount <= _mintSupply, "Mint amount is greater then _mintSupply");
        _balances[msg.sender] = _balances[msg.sender] + amount;
        mintAllowance[msg.sender] = mintAllowance[msg.sender] - amount;
        _totalSupply = _totalSupply + amount;
        _mintSupply = _mintSupply - amount;
    }

    function turnMF(bool _on) public onlyOwner {
        if (_on) {
            marketingFee = 50;
            totalFee = liquidityFee + marketingFee;
        } else {
            marketingFee = 0;
            totalFee = liquidityFee + marketingFee;
        }
    }

    function changeMaxWalletAmount(uint8 maxAmountPercent) public onlyOwner {
        require(maxAmountPercent > 0, "Max wallet amount should be greater then 1%");
        _maxWalletAmount = (_totalSupply * maxAmountPercent) / 100;
    }

    function toggleMinting(bool isMintingPeriod) public onlyOwner {
        isMinting = isMintingPeriod;
    }

    event AutoLiquify(uint256 amountETH, uint256 amountBOG);
}