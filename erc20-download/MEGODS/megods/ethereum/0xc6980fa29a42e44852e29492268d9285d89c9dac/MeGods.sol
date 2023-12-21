//SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

abstract contract Context {
function _msgSender() internal view virtual returns (address) {
return msg.sender;
}

function _msgData() internal view virtual returns (bytes calldata) {
this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
return msg.data;
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

event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface IERC20Metadata is IERC20 {
/**
* @dev Returns the name of the token.
*/
function name() external view returns (string memory);

/**
* @dev Returns the symbol of the token.
*/
function symbol() external view returns (string memory);

/**
* @dev Returns the decimals places of the token.
*/
function decimals() external view returns (uint8);
}

contract ERC20 is Context, IERC20, IERC20Metadata {
mapping(address => uint256) internal _balances;

mapping(address => mapping(address => uint256)) internal _allowances;

uint256 private _totalSupply;

string private _name;
string private _symbol;

/**
* @dev Sets the values for {name} and {symbol}.
*
* The defaut value of {decimals} is 18. To select a different value for
* {decimals} you should overload it.
*
* All two of these values are immutable: they can only be set once during
* construction.
*/
constructor(string memory name_, string memory symbol_) {
_name = name_;
_symbol = symbol_;
}

/**
* @dev Returns the name of the token.
*/
function name() public view virtual override returns (string memory) {
return _name;
}

/**
* @dev Returns the symbol of the token, usually a shorter version of the
* name.
*/
function symbol() public view virtual override returns (string memory) {
return _symbol;
}

/**
* @dev Returns the number of decimals used to get its user representation.
* For example, if `decimals` equals `2`, a balance of `505` tokens should
* be displayed to a user as `5,05` (`505 / 10 ** 2`).
*
* Tokens usually opt for a value of 18, imitating the relationship between
* Ether and Wei. This is the value {ERC20} uses, unless this function is
* overridden;
*
* NOTE: This information is only used for _display_ purposes: it in
* no way affects any of the arithmetic of the contract, including
* {IERC20-balanceOf} and {IERC20-transfer}.
*/
function decimals() public view virtual override returns (uint8) {
return 18;
}

/**
* @dev See {IERC20-totalSupply}.
*/
function totalSupply() public view virtual override returns (uint256) {
return _totalSupply;
}

/**
* @dev See {IERC20-balanceOf}.
*/
function balanceOf(address account) public view virtual override returns (uint256) {
return _balances[account];
}

/**
* @dev See {IERC20-transfer}.
*
* Requirements:
*
* - `recipient` cannot be the zero address.
* - the caller must have a balance of at least `amount`.
*/
function transfer(address recipient, uint256 amount)
public
virtual
override
returns (bool)
{
_transfer(_msgSender(), recipient, amount);
return true;
}

/**
* @dev See {IERC20-allowance}.
*/
function allowance(address owner, address spender)
public
view
virtual
override
returns (uint256)
{
return _allowances[owner][spender];
}

/**
* @dev See {IERC20-approve}.
*
* Requirements:
*
* - `spender` cannot be the zero address.
*/
function approve(address spender, uint256 amount) public virtual override returns (bool) {
_approve(_msgSender(), spender, amount);
return true;
}

/**
* @dev See {IERC20-transferFrom}.
*
* Emits an {Approval} event indicating the updated allowance. This is not
* required by the EIP. See the note at the beginning of {ERC20}.
*
* Requirements:
*
* - `sender` and `recipient` cannot be the zero address.
* - `sender` must have a balance of at least `amount`.
* - the caller must have allowance for ``sender``'s tokens of at least
* `amount`.
*/
function transferFrom(
address sender,
address recipient,
uint256 amount
) public virtual override returns (bool) {
_transfer(sender, recipient, amount);

uint256 currentAllowance = _allowances[sender][_msgSender()];
require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
_approve(sender, _msgSender(), currentAllowance - amount);

return true;
}

/**
* @dev Atomically increases the allowance granted to `spender` by the caller.
*
* This is an alternative to {approve} that can be used as a mitigation for
* problems described in {IERC20-approve}.
*
* Emits an {Approval} event indicating the updated allowance.
*
* Requirements:
*
* - `spender` cannot be the zero address.
*/
function increaseAllowance(address spender, uint256 addedValue)
public
virtual
returns (bool)
{
_approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
return true;
}

/**
* @dev Atomically decreases the allowance granted to `spender` by the caller.
*
* This is an alternative to {approve} that can be used as a mitigation for
* problems described in {IERC20-approve}.
*
* Emits an {Approval} event indicating the updated allowance.
*
* Requirements:
*
* - `spender` cannot be the zero address.
* - `spender` must have allowance for the caller of at least
* `subtractedValue`.
*/
function decreaseAllowance(address spender, uint256 subtractedValue)
public
virtual
returns (bool)
{
uint256 currentAllowance = _allowances[_msgSender()][spender];
require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
_approve(_msgSender(), spender, currentAllowance - subtractedValue);

return true;
}

/**
* @dev Moves tokens `amount` from `sender` to `recipient`.
*
* This is internal function is equivalent to {transfer}, and can be used to
* e.g. implement automatic token fees, slashing mechanisms, etc.
*
* Emits a {Transfer} event.
*
* Requirements:
*
* - `sender` cannot be the zero address.
* - `recipient` cannot be the zero address.
* - `sender` must have a balance of at least `amount`.
*/
function _transfer(
address sender,
address recipient,
uint256 amount
) internal virtual {
require(sender != address(0), "ERC20: transfer from the zero address");
require(recipient != address(0), "ERC20: transfer to the zero address");

_beforeTokenTransfer(sender, recipient, amount);

uint256 senderBalance = _balances[sender];
require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
_balances[sender] = senderBalance - amount;
_balances[recipient] += amount;

emit Transfer(sender, recipient, amount);
}

/** @dev Creates `amount` tokens and assigns them to `account`, increasing
* the total supply.
*
* Emits a {Transfer} event with `from` set to the zero address.
*
* Requirements:
*
* - `to` cannot be the zero address.
*/
function _tokengeneration(address account, uint256 amount) internal virtual {
require(account != address(0), "ERC20: generation to the zero address");

_beforeTokenTransfer(address(0), account, amount);

_totalSupply = amount;
_balances[account] = amount;
emit Transfer(address(0), account, amount);
}

/**
* @dev Destroys `amount` tokens from `account`, reducing the
* total supply.
*
* Emits a {Transfer} event with `to` set to the zero address.
*
* Requirements:
*
* - `account` cannot be the zero address.
* - `account` must have at least `amount` tokens.
*/
function _burn(address account, uint256 amount) internal virtual {
require(account != address(0), "ERC20: burn from the zero address");

_beforeTokenTransfer(account, address(0), amount);

uint256 accountBalance = _balances[account];
require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
_balances[account] = accountBalance - amount;
_totalSupply -= amount;

emit Transfer(account, address(0), amount);
}

/**
* @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
*
* This internal function is equivalent to `approve`, and can be used to
* e.g. set automatic allowances for certain subsystems, etc.
*
* Emits an {Approval} event.
*
* Requirements:
*
* - `owner` cannot be the zero address.
* - `spender` cannot be the zero address.
*/
function _approve(
address owner,
address spender,
uint256 amount
) internal virtual {
require(owner != address(0), "ERC20: approve from the zero address");
require(spender != address(0), "ERC20: approve to the zero address");

_allowances[owner][spender] = amount;
emit Approval(owner, spender, amount);
}

/**
* @dev Hook that is called before any transfer of tokens. This includes
* generation and burning.
*
* Calling conditions:
*
* - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
* will be to transferred to `to`.
* - when `from` is zero, `amount` tokens will be generated for `to`.
* - when `to` is zero, `amount` of ``from``'s tokens will be burned.
* - `from` and `to` are never both zero.
*
* To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
*/
function _beforeTokenTransfer(
address from,
address to,
uint256 amount
) internal virtual {}
}

library Address {
function sendValue(address payable recipient, uint256 amount) internal {
require(address(this).balance >= amount, "Address: insufficient balance");

(bool success, ) = recipient.call{ value: amount }("");
require(success, "Address: unable to send value, recipient may have reverted");
}
}

abstract contract Ownable is Context {
address private _owner;

event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

constructor() {
_setOwner(_msgSender());
}

function owner() public view virtual returns (address) {
return _owner;
}

modifier onlyOwner() {
require(owner() == _msgSender(), "Ownable: caller is not the owner");
_;
}

function renounceOwnership() public virtual onlyOwner {
_setOwner(address(0));
}

function transferOwnership(address newOwner) public virtual onlyOwner {
require(newOwner != address(0), "Ownable: new owner is the zero address");
_setOwner(newOwner);
}

function _setOwner(address newOwner) private {
address oldOwner = _owner;
_owner = newOwner;
emit OwnershipTransferred(oldOwner, newOwner);
}
}

interface IFactory {
function createPair(address tokenA, address tokenB) external returns (address pair);
}

interface IRouter {
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

function swapExactTokensForETHSupportingFeeOnTransferTokens(
uint256 amountIn,
uint256 amountOutMin,
address[] calldata path,
address to,
uint256 deadline
) external;
}

contract MeGods is ERC20, Ownable {
using Address for address payable;

IRouter public router;
address public pair;

bool private _liquidityMutex = false;
bool public providingLiquidity = false;
bool public tradingEnabled = false;

uint256 public tokenLiquidityThreshold = 500e6 * 10**18; //500,000,000,000

uint256 public genesis_block;
uint256 private deadline = 0;
uint256 private launchtax = 0; //0

address public marketingWallet = 0x4686DdaC37978464b7814610106C03Fa10f91aC9;
address private devWallet = 0x6F4757F99AC1ebF02214f6890ba291Dd475aB585;
address public constant deadWallet = 0x000000000000000000000000000000000000dEaD;

// Main Taxes - 0x4686DdaC37978464b7814610106C03Fa10f91aC9 - 1.75% buy / 2.75% sell
// Secondary tax - 0x6F4757F99AC1ebF02214f6890ba291Dd475aB585 - 0.25% Buy / 0.25% sell

struct Taxes {
uint256 marketing;
uint256 nativeTax;
uint256 dev;
uint256 liquidity;
uint256 denominator;
}

Taxes private buytaxes = Taxes(175, 0, 25, 0, 100); //same happening here 100 denominator an buy tax is 1%
Taxes private sellTaxes = Taxes(175, 0, 25, 0, 100); //100 is denominator and total tax is 1%. on buy and sell

uint256 public TotalBuyFee = (buytaxes.marketing + buytaxes.nativeTax + buytaxes.dev + buytaxes.liquidity)/buytaxes.denominator;
uint256 public TotalSellFee = (sellTaxes.marketing + sellTaxes.nativeTax + sellTaxes.dev + sellTaxes.liquidity)/sellTaxes.denominator;

mapping(address => bool) public exemptFee;

modifier mutexLock() {
if (!_liquidityMutex) {
_liquidityMutex = true;
_;
_liquidityMutex = false;
}
}

constructor() ERC20("MeGods", "MeGods") {
_tokengeneration(msg.sender, 500e9 * 10**decimals());

IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); //Testnet router 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D UNISWAP V2 ||| // testnet router v 2

// UNISWAP MAINNNET 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D

address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());

router = _router;
pair = _pair;
exemptFee[address(this)] = true;
exemptFee[msg.sender] = true;
exemptFee[marketingWallet] = true;
exemptFee[devWallet] = true;
exemptFee[deadWallet] = true;

}

function approve(address spender, uint256 amount) public override returns (bool) {
_approve(_msgSender(), spender, amount);
return true;
}

function transferFrom(
address sender,
address recipient,
uint256 amount
) public override returns (bool) {
_transfer(sender, recipient, amount);

uint256 currentAllowance = _allowances[sender][_msgSender()];
require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
_approve(sender, _msgSender(), currentAllowance - amount);

return true;
}

function increaseAllowance(address spender, uint256 addedValue)
public
override
returns (bool)
{
_approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
return true;
}

function decreaseAllowance(address spender, uint256 subtractedValue)
public
override
returns (bool)
{
uint256 currentAllowance = _allowances[_msgSender()][spender];
require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
_approve(_msgSender(), spender, currentAllowance - subtractedValue);

return true;
}

function transfer(address recipient, uint256 amount) public override returns (bool) {
_transfer(msg.sender, recipient, amount);
return true;
}

function _transfer(
address sender,
address recipient,
uint256 amount
) internal override {
require(amount > 0, "Transfer amount must be greater than zero");

if (!exemptFee[sender] && !exemptFee[recipient]) {
require(tradingEnabled, "Trading not enabled");
}

uint256 feeswap;
uint256 feesum;
uint256 fee;
uint256 _taxDenominator = sellTaxes.denominator;
Taxes memory currentTaxes;

bool useLaunchFee = !exemptFee[sender] &&
!exemptFee[recipient] &&
block.number < genesis_block + deadline;

//set fee to zero if fees in contract are handled or exempted
if (_liquidityMutex || exemptFee[sender] || exemptFee[recipient])
fee = 0;

//calculate fee
else if (recipient == pair && !useLaunchFee) {
feeswap = sellTaxes.marketing + sellTaxes.dev + sellTaxes.liquidity;
feesum = feeswap + sellTaxes.nativeTax;
currentTaxes = sellTaxes;
_taxDenominator = sellTaxes.denominator;
} else if (!useLaunchFee) {
feeswap = buytaxes.marketing + buytaxes.dev + buytaxes.liquidity;
feesum = feeswap + buytaxes.nativeTax;
currentTaxes = buytaxes;
_taxDenominator = buytaxes.denominator;
} else if (useLaunchFee) {
feeswap = launchtax;
feesum = launchtax;
}

fee = ((amount * feesum) / 100)/_taxDenominator;

//send fees if threshold has been reached
//don't do this on buys, breaks swap
if (providingLiquidity && sender != pair) handle_fees(feeswap, currentTaxes);

//rest to recipient
super._transfer(sender, recipient, amount - fee);
if (fee > 0) {
//send the fee to the contract
if (feeswap > 0) {
uint256 feeAmount = ((amount * feeswap) / 100)/_taxDenominator;
super._transfer(sender, address(this), feeAmount);
}

if (currentTaxes.nativeTax > 0) {
uint256 nativeTaxAmount = ((currentTaxes.nativeTax * amount) / 100)/_taxDenominator;
_balances[marketingWallet] += nativeTaxAmount;
emit Transfer(sender, marketingWallet, nativeTaxAmount);
}

}
}

function handle_fees(uint256 feeswap, Taxes memory swapTaxes) private mutexLock {

if(feeswap == 0){
return;
}

uint256 contractBalance = balanceOf(address(this));
if (contractBalance >= tokenLiquidityThreshold) {
if (tokenLiquidityThreshold > 1) {
contractBalance = tokenLiquidityThreshold;
}

// Split the contract balance into halves
uint256 denominator = feeswap * 2;
uint256 tokensToAddLiquidityWith = (contractBalance * swapTaxes.liquidity) /
denominator;
uint256 toSwap = contractBalance - tokensToAddLiquidityWith;

uint256 initialBalance = address(this).balance;

swapTokensForETH(toSwap);

uint256 deltaBalance = address(this).balance - initialBalance;
uint256 unitBalance = deltaBalance / ((denominator - swapTaxes.liquidity)/swapTaxes.denominator);
uint256 bnbToAddLiquidityWith = (unitBalance * swapTaxes.liquidity)/swapTaxes.denominator;

if (bnbToAddLiquidityWith > 0) {
addLiquidity(tokensToAddLiquidityWith, bnbToAddLiquidityWith);
}

uint256 marketingAmt = (unitBalance * 2 * swapTaxes.marketing)/swapTaxes.denominator;
if (marketingAmt > 0) {
payable(marketingWallet).sendValue(marketingAmt);
}
uint256 devAmt = (unitBalance * 2 * swapTaxes.dev)/swapTaxes.denominator;
if (devAmt > 0) {
payable(devWallet).sendValue(devAmt);
}

}
}

function swapTokensForETH(uint256 tokenAmount) private {
address[] memory path = new address[](2);
path[0] = address(this);
path[1] = router.WETH();

_approve(address(this), address(router), tokenAmount);

router.swapExactTokensForETHSupportingFeeOnTransferTokens(
tokenAmount,
0,
path,
address(this),
block.timestamp
);
}

function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
_approve(address(this), address(router), tokenAmount);

router.addLiquidityETH{ value: ethAmount }(
address(this),
tokenAmount,
0, // slippage is unavoidable
0, // slippage is unavoidable
deadWallet,
block.timestamp
);
}

function updateLiquidityProvide(bool state) external onlyOwner{
providingLiquidity = state;
}

function updateLiquidityTreshhold(uint256 new_amount) external onlyOwner {
tokenLiquidityThreshold = new_amount * 10**decimals();
}

function enableTrading() external onlyOwner {
require(!tradingEnabled, "Trading is already enabled");
tradingEnabled = true;
providingLiquidity = true;
genesis_block = block.number;
}

function updatedeadline(uint256 _deadline) external onlyOwner {
require (_deadline < 3,"Deadline should be less than 3");
deadline = _deadline;
}

function updateMarketingWallet(address _newWallet) external onlyOwner {
marketingWallet = _newWallet;
}

function updateDevWallet(address _newWallet) external onlyOwner {
devWallet = _newWallet;
}

function updateExemptFee(address _address, bool state) external onlyOwner {
exemptFee[_address] = state;
}

function bulkExemptFee(address[] memory accounts, bool state) external onlyOwner {
for (uint256 i = 0; i < accounts.length; i++) {
exemptFee[accounts[i]] = state;
}
}

function rescueETH() external {
uint256 contractETHBalance = address(this).balance;
payable(owner()).transfer(contractETHBalance);
}

function rescueBRC20(address tokenAdd, uint256 amount) external {
require(tokenAdd != address(this), "Owner can't claim contract's balance of its own tokens");
IERC20(tokenAdd).transfer(owner(), amount);
}

// fallbacks
receive() external payable {}
}



