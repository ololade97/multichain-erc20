//SPDX-License-Identifier: MIT
pragma solidity 0.8.14;

import "./IERC20.sol";
import "./Ownable.sol";
import "./SafeMath.sol";

interface IFeeReceiver {
    function trigger() external;
}

interface IEmissionRecipient {
    function trigger() external;
}

interface ISwapper {
    function buy(address user) external payable;
    function sell(address user) external;
}

/**
    Modular Upgradeable Token
    Token System Designed By DeFi Mark
 */
contract Stasis is IERC20, Ownable {

    using SafeMath for uint256;

    // total supply
    uint256 private _totalSupply = 260_000_000 * 10**18;

    // token data
    string private constant _name = 'Stasis';
    string private constant _symbol = 'STS';
    uint8  private constant _decimals = 18;

    // balances
    mapping (address => uint256) private _balances;
    mapping (address => mapping (address => uint256)) private _allowances;

    // Swapper
    address public swapper;

    // Zero & DEAD addresses
    address private immutable DEAD_ADDRESS = 0x000000000000000000000000000000000000dEaD;
    address private immutable ZERO_ADDRESS = 0x0000000000000000000000000000000000000000;

    // Amount Burned
    uint256 public totalBurned;

    // Taxation on transfers
    uint256 public buyFee             = 500;
    uint256 public sellFee            = 1000;
    uint256 public transferFee        = 0;
    uint256 public constant TAX_DENOM = 10000;

    // permissions
    struct Permissions {
        bool isFeeExempt;
        bool isLiquidityPool;
    }
    mapping ( address => Permissions ) public permissions;

    // Fee Recipients
    address public sellFeeRecipient;
    address public buyFeeRecipient;
    address public transferFeeRecipient;

    // Trigger Fee Recipients
    bool public triggerBuyRecipient = true;
    bool public triggerTransferRecipient = false;
    bool public triggerSellRecipient = false;

    // Launched, allows set up without bots
    bool public launched = false;

    // events
    event SetBuyFeeRecipient(address recipient);
    event SetSellFeeRecipient(address recipient);
    event SetTransferFeeRecipient(address recipient);
    event SetFeeExemption(address account, bool isFeeExempt);
    event SetAutomatedMarketMaker(address account, bool isMarketMaker);
    event SetFees(uint256 buyFee, uint256 sellFee, uint256 transferFee);
    event SetSwapper(address newSwapper);
    event Launched(uint256 blockNo);
    event SetAutoTriggers(bool triggerBuy, bool triggerSell, bool triggerTransfer);

    constructor() {

        // exempt sender for tax-free initial distribution
        permissions[msg.sender].isFeeExempt = true;

        // initial supply allocation
        _balances[msg.sender] = _totalSupply;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    /////////////////////////////////
    /////    ERC20 FUNCTIONS    /////
    /////////////////////////////////

    function totalSupply() external view override returns (uint256) { return _totalSupply; }
    function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
    function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
    
    function name() public pure override returns (string memory) {
        return _name;
    }

    function symbol() public pure override returns (string memory) {
        return _symbol;
    }

    function decimals() public pure override returns (uint8) {
        return _decimals;
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        _allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    /** Transfer Function */
    function transfer(address recipient, uint256 amount) external override returns (bool) {
        if (msg.sender == recipient) {
            return _sell(amount, msg.sender);
        } else {
            return _transferFrom(msg.sender, recipient, amount);
        }
    }

    /** Transfer Function */
    function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
        _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, 'Insufficient Allowance');
        return _transferFrom(sender, recipient, amount);
    }


    /////////////////////////////////
    /////   PUBLIC FUNCTIONS    /////
    /////////////////////////////////

    function burn(uint256 amount) external returns (bool) {
        return _burn(msg.sender, amount);
    }

    function burnFrom(address account, uint256 amount) external returns (bool) {
        _allowances[account][msg.sender] = _allowances[account][msg.sender].sub(amount, 'Insufficient Allowance');
        return _burn(account, amount);
    }

    function sell(uint256 amount) external returns (bool) {
        return _sell(amount, msg.sender);
    }

    function sellFor(uint256 amount, address recipient) external returns (bool) {
        return _sell(amount, recipient);
    }

    function buyFor(address account) external payable {
        require(
            account != ZERO_ADDRESS ||
            account != DEAD_ADDRESS, "Zero Address!"
            );

        ISwapper(swapper).buy{value: msg.value}(account);
    }

    receive() external payable {
        ISwapper(swapper).buy{value: address(this).balance}(msg.sender);
    }

    /////////////////////////////////
    /////    OWNER FUNCTIONS    /////
    /////////////////////////////////

    function withdraw(address token) external onlyOwner {
        require(token != address(0), 'Zero Address');
        bool s = IERC20(token).transfer(msg.sender, IERC20(token).balanceOf(address(this)));
        require(s, 'Failure On Token Withdraw');
    }

    function withdrawBNB() external onlyOwner {
        (bool s,) = payable(msg.sender).call{value: address(this).balance}("");
        require(s);
    }

    function setTransferFeeRecipient(address recipient) external onlyOwner {
        require(recipient != address(0), 'Zero Address');

        permissions[transferFeeRecipient].isFeeExempt = false;

        transferFeeRecipient = recipient;
        permissions[recipient].isFeeExempt = true;
        emit SetTransferFeeRecipient(recipient);
    }

    function setBuyFeeRecipient(address recipient) external onlyOwner {
        require(recipient != address(0), 'Zero Address');

        permissions[transferFeeRecipient].isFeeExempt = false;

        buyFeeRecipient = recipient;
        permissions[recipient].isFeeExempt = true;
        emit SetBuyFeeRecipient(recipient);
    }

    function setSellFeeRecipient(address recipient) external onlyOwner {
        require(recipient != address(0), 'Zero Address');
        
        permissions[transferFeeRecipient].isFeeExempt = false;

        sellFeeRecipient = recipient;
        permissions[recipient].isFeeExempt = true;
        emit SetSellFeeRecipient(recipient);
    }

    function registerAutomatedMarketMaker(address account) external onlyOwner {
        require(account != address(0), 'Zero Address');
        require(!permissions[account].isLiquidityPool, 'Already An AMM');
        permissions[account].isLiquidityPool = true;
        emit SetAutomatedMarketMaker(account, true);
    }

    function unRegisterAutomatedMarketMaker(address account) external onlyOwner {
        require(account != address(0), 'Zero Address');
        require(permissions[account].isLiquidityPool, 'Not An AMM');
        permissions[account].isLiquidityPool = false;
        emit SetAutomatedMarketMaker(account, false);
    }

    function setAutoTriggers(
        bool autoBuyTrigger,
        bool autoTransferTrigger,
        bool autoSellTrigger
    ) external onlyOwner {
        triggerBuyRecipient = autoBuyTrigger;
        triggerTransferRecipient = autoTransferTrigger;
        triggerSellRecipient = autoSellTrigger;
        emit SetAutoTriggers(autoBuyTrigger, autoSellTrigger, autoTransferTrigger);
    }

    function setFees(uint _buyFee, uint _sellFee, uint _transferFee) external onlyOwner {
        require(
            _buyFee <= 2000,
            'Buy Fee Too High'
        );
        require(
            _sellFee <= 2000,
            'Sell Fee Too High'
        );
        require(
            _transferFee <= 2000,
            'Transfer Fee Too High'
        );

        buyFee = _buyFee;
        sellFee = _sellFee;
        transferFee = _transferFee;

        emit SetFees(_buyFee, _sellFee, _transferFee);
    }

    function setFeeExempt(address account, bool isExempt) external onlyOwner {
        require(account != address(0), 'Zero Address');
        permissions[account].isFeeExempt = isExempt;
        emit SetFeeExemption(account, isExempt);
    }

    function setSwapper(address newSwapper) external onlyOwner {
        require(
            newSwapper != address(0),
            'Zero Address'
        );
        swapper = newSwapper;
        emit SetSwapper(newSwapper);
    }

    function launch() external onlyOwner {
        require(launched == false, 'Already Launched');
        launched = true;
        emit Launched(block.number);
    }


    /////////////////////////////////
    /////     READ FUNCTIONS    /////
    /////////////////////////////////

    function getTax(address sender, address recipient, uint256 amount) public view returns (uint256, address, bool) {
        if ( permissions[sender].isFeeExempt || permissions[recipient].isFeeExempt ) {
            return (0, address(0), false);
        }
        return permissions[sender].isLiquidityPool ? 
               (amount.mul(buyFee).div(TAX_DENOM), buyFeeRecipient, triggerBuyRecipient) : 
               permissions[recipient].isLiquidityPool ? 
               (amount.mul(sellFee).div(TAX_DENOM), sellFeeRecipient, triggerSellRecipient) :
               (amount.mul(transferFee).div(TAX_DENOM), transferFeeRecipient, triggerTransferRecipient);
    }

    //////////////////////////////////
    /////   INTERNAL FUNCTIONS   /////
    //////////////////////////////////

    /** Internal Transfer */
    function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
        require(
            recipient != address(0),
            'Zero Recipient'
        );
        require(
            amount > 0,
            'Zero Amount'
        );
        require(
            amount <= balanceOf(sender),
            'Insufficient Balance'
        );

        // make pre-launch checks
        if (!launched) {
            require(
                sender == this.getOwner(),
                'Only Owner Can Transfer Tokens Pre Launch'
            );
        }
        
        // decrement sender balance
        _balances[sender] -= amount;

        // fee for transaction
        (uint256 fee, address feeDestination, bool trigger) = getTax(sender, recipient, amount);

        // give amount to recipient less fee
        uint256 sendAmount = amount - fee;
        _balances[recipient] += sendAmount;
        emit Transfer(sender, recipient, sendAmount);

        // allocate fee if any
        if (fee > 0) {

            // if recipient field is valid
            bool isValidRecipient = feeDestination != ZERO_ADDRESS && feeDestination != DEAD_ADDRESS && feeDestination != address(this);

            // allocate amount to recipient
            address feeRecipient = isValidRecipient ? feeDestination : address(this);
            _balances[feeRecipient] = _balances[feeRecipient].add(fee);
            emit Transfer(sender, feeRecipient, fee);

            // if valid and trigger is enabled, trigger tokenomics mid transfer
            if (trigger && isValidRecipient) {
                uint256 _length;

                assembly {
                    _length:= extcodesize(feeRecipient)
                }

                if(_length == 0) {
                    return true;
                } else {
                    IFeeReceiver(feeRecipient).trigger();
                }
            }
        }
        return true;
    }

    function _burn(address account, uint256 amount) internal returns (bool) {
        require(
            account != address(0),
            'Zero Address'
        );
        require(
            amount > 0,
            'Zero Amount'
        );
        require(
            amount <= balanceOf(account),
            'Insufficient Balance'
        );

        // delete from balance and supply
        _balances[account] = _balances[account].sub(amount, 'Balance Underflow');
        _totalSupply = _totalSupply.sub(amount, 'Supply Underflow');

        // increment total burned
        unchecked {
            totalBurned += amount;
        }

        // emit transfer
        emit Transfer(account, address(0), amount);
        return true;
    }

    function _sell(uint256 amount, address recipient) internal returns (bool) {
        require(
            amount > 0,
            'Zero Amount'
        );
        require(
            recipient != address(0) && recipient != address(this) && recipient != swapper,
            'Invalid Recipient'
        );
        require(
            amount <= balanceOf(msg.sender),
            'Insufficient Balance'
        );

        // re-allocate balances
        _balances[msg.sender] = _balances[msg.sender].sub(amount);
        _balances[swapper] = _balances[swapper].add(amount);
        emit Transfer(msg.sender, swapper, amount);

        // sell token for user
        ISwapper(swapper).sell(recipient);
        return true;
    }
}