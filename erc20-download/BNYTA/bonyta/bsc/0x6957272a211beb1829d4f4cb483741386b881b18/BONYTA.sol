// SPDX-License-Identifier: Unlicensed 
// This contract is not open source and can not be used/forked without permission
// Custom Contract Created for BONYTA by Gen (tokensbygen.com)


/*

    https://bonyta.org

*/

pragma solidity 0.8.19;
 
interface IERC20 {

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint256);
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

interface IUniswapV2Factory {
    function createPair(address tokenA, address tokenB) external returns (address pair);
}

interface IUniswapV2Pair {
    function factory() external view returns (address);
}

interface IUniswapV2Router02 {

    function factory() external pure returns (address);
    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);

    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }
}


contract BONYTA is Context, IERC20 { 

    // Contract Wallets
    address private _owner = payable(0x99f2A43d66fb2467A56445424BC064b180C0D14F); 
    address private constant Wallet_Burn = 0x000000000000000000000000000000000000dEaD; 

    address public Wallet_Liquidity = 0x99f2A43d66fb2467A56445424BC064b180C0D14F; 
    address public Wallet_Tokens = 0x99f2A43d66fb2467A56445424BC064b180C0D14F; 
    address payable public Wallet_Marketing = payable(0x99f2A43d66fb2467A56445424BC064b180C0D14F);  
    address payable public Wallet_Charity = payable(0x99f2A43d66fb2467A56445424BC064b180C0D14F); 

    // Token Info
    string private constant  _name     = "BONYTA";
    string private constant  _symbol   = "BNYTA";
    uint256 private constant _decimals = 18; 
    uint256 private constant _tTotal   = 600_000_000_000_000 * (10 ** _decimals);
    uint256 private max_Hold           = _tTotal;
    uint256 private max_Tran           = _tTotal;

    // Project links
    string private _Website;
    string private _Telegram;
    string private _LP_Lock;

    // Fees
    uint8 public _Fee__Buy_Charity;
    uint8 public _Fee__Buy_Liquidity;
    uint8 public _Fee__Buy_Marketing;
    uint8 public _Fee__Buy_Reflection;
    uint8 public _Fee__Buy_Tokens;

    uint8 public _Fee__Sell_Charity;
    uint8 public _Fee__Sell_Liquidity;
    uint8 public _Fee__Sell_Marketing;
    uint8 public _Fee__Sell_Reflection;
    uint8 public _Fee__Sell_Tokens;

    // Total Fee for Swap
    uint256 private _SwapFeeTotal_Buy;
    uint256 private _SwapFeeTotal_Sell;


    // Supply Tracking for RFI
    uint256 private _tFeeTotal;
    uint256 private constant MAX = ~uint256(0);
    uint256 private _rTotal = (MAX - (MAX % _tTotal));

    // Set factory
    IUniswapV2Router02 public uniswapV2Router;
    address public uniswapV2Pair;

    constructor () {

        // Transfer token supply to owner wallet
        _rOwned[_owner] = _rTotal;

        // Set PancakeSwap Router Address
        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x10ED43C718714eb63d5aA57B78B54704E256024E);

        // Create initial liquidity pair with BNB on PancakeSwap factory
        uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
        uniswapV2Router = _uniswapV2Router;

        // Wallets excluded from holding limits
        _isLimitExempt[_owner] = true;
        _isLimitExempt[address(this)] = true;
        _isLimitExempt[Wallet_Burn] = true;
        _isLimitExempt[uniswapV2Pair] = true;
        _isLimitExempt[Wallet_Tokens] = true;

        // Wallets excluded from fees
        _isExcludedFromFee[_owner] = true;
        _isExcludedFromFee[address(this)] = true;
        _isExcludedFromFee[Wallet_Burn] = true;

        // Set the initial liquidity pair
        _isPair[uniswapV2Pair] = true;    

        // Exclude from Rewards
        _isExcludedFromRewards[Wallet_Burn] = true;
        _isExcludedFromRewards[uniswapV2Pair] = true;
        _isExcludedFromRewards[address(this)] = true;

        // Push excluded wallets to array
        _excluded.push(Wallet_Burn);
        _excluded.push(uniswapV2Pair);
        _excluded.push(address(this));

        // Wallets granted access before trade is open
        _isWhiteListed[_owner] = true;

        // Emit Supply Transfer to Owner
        emit Transfer(address(0), _owner, _tTotal);

        // Emit ownership transfer
        emit OwnershipTransferred(address(0), _owner);

    }

    
    // Events
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event updated_Wallet_Limits(uint256 max_Tran, uint256 max_Hold);
    event updated_Buy_fees(uint256 Marketing, uint256 Liquidity, uint256 Reflection, uint256 Chairty, uint256 Tokens);
    event updated_Sell_fees(uint256 Marketing, uint256 Liquidity, uint256 Reflection, uint256 Chairty, uint256 Tokens);
    event updated_SwapAndLiquify_Enabled(bool Swap_and_Liquify_Enabled);
    event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived, uint256 tokensIntoLiqudity);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);


    // Restrict function to contract owner only 
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    // Address mappings
    mapping (address => uint256) private _tOwned;                               // Tokens Owned
    mapping (address => uint256) private _rOwned;                               // Reflected balance
    mapping (address => mapping (address => uint256)) private _allowances;      // Allowance to spend another wallets tokens
    mapping (address => bool) public _isExcludedFromFee;                        // Wallets that do not pay fees
    mapping (address => bool) public _isExcludedFromRewards;                    // Excluded from RFI rewards
    mapping (address => bool) public _isWhiteListed;                            // Wallets that have access before trade is open
    mapping (address => bool) public _isLimitExempt;                            // Wallets that are excluded from HOLD and TRANSFER limits
    mapping (address => bool) public _isPair;                                   // Address is liquidity pair
    address[] private _excluded;                                                // Array of wallets excluded from rewards



    // Fee Processing Triggers
    uint8 private swapTrigger = 15;
    uint8 private swapCounter = 1;    
    
    // SwapAndLiquify Switch                  
    bool public processingFees;
    bool public autoFeeProcessing; 

    // Launch Settings
    bool public tradeOpen;
    bool public freeWalletTransfers = true;

    // Fee Tracker
    bool private takeFee;



    // Project info
    function Project_Information() external view returns(address Owner_Wallet,
                                                         uint256 Transaction_Limit,
                                                         uint256 Max_Wallet,
                                                         uint256 Fee_When_Buying,
                                                         uint256 Fee_When_Selling,
                                                         string memory Website,
                                                         string memory Telegram,
                                                         string memory Liquidity_Lock,
                                                         string memory Custom_Contract_By) {
                                                           
        string memory Creator = "https://t.me/GenTokens_GEN";

        uint8 Total_buy =  _Fee__Buy_Charity      +
                           _Fee__Buy_Liquidity    +
                           _Fee__Buy_Marketing    +
                           _Fee__Buy_Reflection   +
                           _Fee__Buy_Tokens       ;

        uint8 Total_sell = _Fee__Sell_Charity     +
                           _Fee__Sell_Liquidity   +
                           _Fee__Sell_Marketing   +
                           _Fee__Sell_Reflection  +
                           _Fee__Sell_Tokens      ;

        uint256 _max_Hold = max_Hold / (10 ** _decimals);
        uint256 _max_Tran = max_Tran / (10 ** _decimals);

        if (_max_Tran > _max_Hold) {_max_Tran = _max_Hold;}

        // Return Token Data
        return (_owner,
                _max_Tran,
                _max_Hold,
                Total_buy,
                Total_sell,
                _Website,
                _Telegram,
                _LP_Lock,
                Creator);

    }
    

    // Set Fees
    function C01__Set_Fees( 

        uint8 Marketing_on_BUY, 
        uint8 Charity_on_BUY,  
        uint8 Liquidity_on_BUY, 
        uint8 Tokens_on_BUY,
        uint8 Reflection_on_BUY,
        
        uint8 Marketing_on_SELL,
        uint8 Charity_on_SELL, 
        uint8 Liquidity_on_SELL, 
        uint8 Tokens_on_SELL,
        uint8 Reflection_on_SELL

        ) external onlyOwner {

        // Buyer Protection: Max Fee 9% 
        require (Marketing_on_BUY    + 
                 Liquidity_on_BUY    + 
                 Charity_on_BUY      + 
                 Tokens_on_BUY       +
                 Reflection_on_BUY   < 10, "E01"); // Total buy fee must be 9 or less 


        // Seller Protection: Max Fee 10% 
        require (Marketing_on_SELL   + 
                 Liquidity_on_SELL   + 
                 Charity_on_SELL     + 
                 Tokens_on_SELL      +
                 Reflection_on_SELL  < 11, "E02"); // Total sell fee must be 10 or less 

        // Update Buy Fees
        _Fee__Buy_Marketing   = Marketing_on_BUY;
        _Fee__Buy_Liquidity   = Liquidity_on_BUY;
        _Fee__Buy_Charity     = Charity_on_BUY;
        _Fee__Buy_Tokens      = Tokens_on_BUY;
        _Fee__Buy_Reflection  = Reflection_on_BUY;

        // Update Sell Fees
        _Fee__Sell_Marketing  = Marketing_on_SELL;
        _Fee__Sell_Liquidity  = Liquidity_on_SELL;
        _Fee__Sell_Charity    = Charity_on_SELL;
        _Fee__Sell_Tokens     = Tokens_on_SELL;
        _Fee__Sell_Reflection = Reflection_on_SELL;

        // Fees For Processing
        _SwapFeeTotal_Buy     = _Fee__Buy_Marketing + _Fee__Buy_Liquidity + _Fee__Buy_Charity;
        _SwapFeeTotal_Sell    = _Fee__Sell_Marketing + _Fee__Sell_Liquidity + _Fee__Sell_Charity;

        emit updated_Buy_fees(_Fee__Buy_Marketing, _Fee__Buy_Liquidity, _Fee__Buy_Charity, _Fee__Buy_Tokens, _Fee__Buy_Reflection);
        emit updated_Sell_fees(_Fee__Sell_Marketing, _Fee__Sell_Liquidity, _Fee__Sell_Charity, _Fee__Sell_Tokens, _Fee__Sell_Reflection);
    }


    /*
    
    ------------------------------------------
    SET MAX TRANSACTION AND MAX HOLDING LIMITS
    ------------------------------------------

    Wallet limits are set as a number of tokens, not as a percent of supply!

    Total Supply = 600,000,000,000,000


    Common Percent Values in Tokens (To avoid mistakes, when setting wallet limits, copy and paste these numbers)

        0.5% = 3000000000000  (This is the lowest permitted value for wallet limits)
        1.0% = 6000000000000
        1.5% = 9000000000000
        2.0% = 12000000000000
        2.5% = 15000000000000
        3.0% = 18000000000000

        100% = 600000000000000 (Only used when setting up the contract for pre-sale etc.)


    */

    function C02__Wallet_Limits(

        uint256 Max_Tokens_Each_Transaction,
        uint256 Max_Total_Tokens_Per_Wallet 

        ) external onlyOwner {

        // Buyer protection - Minimum limits 0.5% Transaction, 0.5% wallet
        require(Max_Tokens_Each_Transaction > 2999999999999, "E03"); // 0.5% minimum limit
        require(Max_Total_Tokens_Per_Wallet > 2999999999999, "E04"); // 0.5% minimum limit
        
        max_Tran = Max_Tokens_Each_Transaction * (10**_decimals);
        max_Hold = Max_Total_Tokens_Per_Wallet * (10**_decimals);

        emit updated_Wallet_Limits(max_Tran, max_Hold);

    }


    // Open Trade
    function C04__Open_Trade() external onlyOwner {

        require(!tradeOpen);
        autoFeeProcessing = true;
        tradeOpen = true;

    }


    /*

    ----------------------
    UPDATE PROJECT WALLETS
    ----------------------

    */



    function Update_Wallet_Liquidity(

        address Liquidity_Collection_Wallet

        ) external onlyOwner {

        require(Liquidity_Collection_Wallet != address(0), "E07"); // Enter a valid BSC Address
        Wallet_Liquidity = Liquidity_Collection_Wallet;

    }

    function Update_Wallet_Marketing(

        address payable Marketing_Wallet

        ) external onlyOwner {

        require(Marketing_Wallet != address(0), "E08"); // Enter a valid BSC Address
        Wallet_Marketing = payable(Marketing_Wallet);

    }

    function Update_Wallet_Charity(

        address payable Charity_Wallet

        ) external onlyOwner {

        require(Charity_Wallet != address(0), "E08"); // Enter a valid BSC Address
        Wallet_Charity = payable(Charity_Wallet);

    }

    function Update_Wallet_Tokens(

        address Token_Fee_Wallet

        ) external onlyOwner {

        require(Token_Fee_Wallet != address(0), "E09"); // Enter a valid BSC Address
        Wallet_Tokens = payable(Token_Fee_Wallet);

    }


    /*

    --------------------
    UPDATE PROJECT LINKS
    --------------------

    */

    function Update_Link_Website(

        string memory Website_URL

        ) external onlyOwner{

        _Website = Website_URL;

    }


    function Update_Link_Telegram(

        string memory Telegram_URL

        ) external onlyOwner{

        _Telegram = Telegram_URL;

    }


    function Update_Link_Liquidity_Lock(

        string memory LP_Lock_URL

        ) external onlyOwner{

        _LP_Lock = LP_Lock_URL;

    }


    // Add Liquidity Pair - required for correct fee calculations 
    function Maintenance__Add_Liquidity_Pair(

        address Wallet_Address,
        bool true_or_false)

        external onlyOwner {

        _isPair[Wallet_Address] = true_or_false;
        _isLimitExempt[Wallet_Address] = true_or_false;
        _isExcludedFromRewards[Wallet_Address] = true;

        // Push excluded wallets to array
        _excluded.push(Wallet_Address);
    } 

    /* 

    ----------------------------
    CONTRACT OWNERSHIP FUNCTIONS
    ----------------------------

    Before renouncing ownership, set the freeWalletTransfers to false 

    */
  
    // Renounce Ownership - To prevent accidental renounce, you must enter the Confirmation_Code: 1234
    function Maintenance__Ownership_RENOUNCE(uint256 Confirmation_Code) public virtual onlyOwner {

        require(Confirmation_Code == 1234, "E10"); // Renounce confirmation not correct

        // Remove old owner status 
        _isLimitExempt[owner()]     = false;
        _isExcludedFromFee[owner()] = false;
        _isWhiteListed[owner()]     = false;

        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    // Transfer to New Owner - To prevent accidental renounce, you must enter the Confirmation_Code: 1234
    function Maintenance__Ownership_TRANSFER(address payable newOwner, uint256 Confirmation_Code) public onlyOwner {

        require(Confirmation_Code == 1234, "E11"); // Renounce confirmation not correct
        require(newOwner != address(0), "E12"); // Enter a valid BSC wallet

        // Revoke old owner status
        _isLimitExempt[owner()]     = false;
        _isExcludedFromFee[owner()] = false;
        _isWhiteListed[owner()]     = false;

        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;

        // Set up new owner status 
        _isLimitExempt[owner()]     = true;
        _isExcludedFromFee[owner()] = true;
        _isWhiteListed[owner()]     = true;

    }



    /*
    
    ---------------------------------
    NO FEE WALLET TO WALLET TRANSFERS 
    ---------------------------------

    Default = true

    Having no fee on wallet-to-wallet transfers means that people can move tokens between wallets, 
    or send them to friends etc without incurring a fee. 

    If false, the 'Buy' fee will apply to all wallet to wallet transfers.

    */

    function Options__Free_Wallet_Transfers(bool true_or_false) public onlyOwner {

        freeWalletTransfers = true_or_false;

    }



    /*

    --------------
    FEE PROCESSING
    --------------

    */

    // Auto Fee Processing Switch (SwapAndLiquify)
    function Processing__Auto_Process(bool true_or_false) external onlyOwner {
        autoFeeProcessing = true_or_false;
        emit updated_SwapAndLiquify_Enabled(true_or_false);
    }

    // Manually Process Fees
    function Processing__Process_Now (uint256 Percent_of_Tokens_to_Process) external onlyOwner {

        require(!processingFees, "E14"); // Already in swap, try later

        if (Percent_of_Tokens_to_Process > 100){Percent_of_Tokens_to_Process == 100;}
        uint256 tokensOnContract = balanceOf(address(this));
        uint256 sendTokens = tokensOnContract * Percent_of_Tokens_to_Process / 100;
        swapAndLiquify(sendTokens);

    }

    // Update Swap Count Trigger
    function Processing__Swap_Trigger_Count(uint8 Transaction_Count) external onlyOwner {

        swapTrigger = Transaction_Count + 1; // Reset to 1 (not 0) to save gas
    }

    // Rescue Tokens Accidentally Sent to Contract Address (need to include decimals!)
    function Processing__Rescue_Tokens(

        address token_Address,
        uint256 number_of_Tokens

        ) external onlyOwner {

            require (token_Address != address(this), "E15"); // Can not remove the native token
            IERC20(token_Address).transfer(msg.sender, number_of_Tokens);
            
    }





    /*

    ------------------
    REFLECTION REWARDS
    ------------------

    The following functions are used to exclude or include a wallet in the reflection rewards.
    By default, all wallets are included. 

    Wallets that are excluded:

            The Burn address 
            The Liquidity Pair
            The Contract Address

    ----------------------------------------
    *** WARNING - DoS 'OUT OF GAS' Risk! ***
    ----------------------------------------

    A reflections contract needs to loop through all excluded wallets to correctly process several functions. 
    This loop can break the contract if it runs out of gas before completion.

    To prevent this, keep the number of wallets that are excluded from rewards to an absolute minimum. 
    In addition to the default excluded wallets, you may need to exclude the address of any locked tokens.

    */


    // Wallet will not get reflections
    function Rewards_Exclude_Wallet(address account) public onlyOwner() {
        require(!_isExcludedFromRewards[account], "Account is already excluded");
        if(_rOwned[account] > 0) {
            _tOwned[account] = tokenFromReflection(_rOwned[account]);
        }
        _isExcludedFromRewards[account] = true;
        _excluded.push(account);
    }


    // Wallet will get reflections - DEFAULT
    function Rewards_Include_Wallet(address account) external onlyOwner() {
        require(_isExcludedFromRewards[account], "Account is already included");
        for (uint256 i = 0; i < _excluded.length; i++) {
            if (_excluded[i] == account) {
                _excluded[i] = _excluded[_excluded.length - 1];
                _tOwned[account] = 0;
                _isExcludedFromRewards[account] = false;
                _excluded.pop();
                break;
            }
        }
    }
    





    /*

    ---------------
    WALLET SETTINGS
    ---------------

    */

    // Exclude From Fees
    function Wallet__Exclude_From_Fees(

        address Wallet_Address,
        bool true_or_false

        ) external onlyOwner {
        _isExcludedFromFee[Wallet_Address] = true_or_false;

    }

    // Exclude From Transaction and Holding Limits
    function Wallet__Exempt_From_Limits(

        address Wallet_Address,
        bool true_or_false

        ) external onlyOwner {  
        _isLimitExempt[Wallet_Address] = true_or_false;
    }

    // Grant Pre-Launch Access (Whitelist)
    function Wallet__Pre_Launch_Access(

        address Wallet_Address,
        bool true_or_false

        ) external onlyOwner {    
        _isWhiteListed[Wallet_Address] = true_or_false;
    }




    /*

    -----------------------------
    BEP20 STANDARD AND COMPLIANCE
    -----------------------------

    */

    function owner() public view returns (address) {
        return _owner;
    }

    function name() public pure returns (string memory) {
        return _name;
    }

    function symbol() public pure returns (string memory) {
        return _symbol;
    }

    function decimals() public pure returns (uint256) {
        return _decimals;
    }

    function totalSupply() public pure override returns (uint256) {
        return _tTotal;
    }

    function balanceOf(address account) public view override returns (uint256) {
        if (_isExcludedFromRewards[account]) return _tOwned[account];
        return tokenFromReflection(_rOwned[account]);
    }

    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        uint256 currentAllowance = _allowances[_msgSender()][spender];
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
        _approve(_msgSender(), spender, currentAllowance - subtractedValue);

        return true;
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }
    
    function _approve(address owner, address spender, uint256 amount) private {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }
   
    function tokenFromReflection(uint256 _rAmount) internal view returns(uint256) {
        require(_rAmount <= _rTotal, "rAmount can not be greater than rTotal");
        uint256 currentRate =  _getRate();
        return _rAmount / currentRate;
    }

    function _getRate() private view returns(uint256) {
        (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
        return rSupply / tSupply;
    }

    function _getCurrentSupply() private view returns(uint256, uint256) {
        uint256 rSupply = _rTotal;
        uint256 tSupply = _tTotal;      
        for (uint256 i = 0; i < _excluded.length; i++) {
            if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
            rSupply = rSupply - _rOwned[_excluded[i]];
            tSupply = tSupply - _tOwned[_excluded[i]];
        }
        if (rSupply < _rTotal / _tTotal) return (_rTotal, _tTotal);
        return (rSupply, tSupply);
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);

        uint256 currentAllowance = _allowances[sender][_msgSender()];
        require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
        _approve(sender, _msgSender(), currentAllowance - amount);

        return true;
    }

    function send_BNB(address _to, uint256 _amount) internal returns (bool SendSuccess) {
                                
        (SendSuccess,) = payable(_to).call{value: _amount}("");

    }

    function getCirculatingSupply() public view returns (uint256) {
        return (_tTotal - balanceOf(address(Wallet_Burn)));
    }




    /*

    ---------------
    TOKEN TRANSFERS
    ---------------

    */

    function _transfer(
        address from,
        address to,
        uint256 amount
      ) private {


        require(balanceOf(from) >= amount, "E16"); // Sender does not have enough tokens!


        if (!tradeOpen){

            require(_isWhiteListed[from] || _isWhiteListed[to], "E17");
        }


        // Wallet Limit
        if (!_isLimitExempt[to] && from != owner()) {

            uint256 heldTokens = balanceOf(to);
            require((heldTokens + amount) <= max_Hold, "E20"); // Over max wallet limit

        }


        // Transaction limit - To send over the transaction limit the sender AND the recipient must be limit exempt
        if (!_isLimitExempt[to] || !_isLimitExempt[from]){

            require(amount <= max_Tran, "E21"); // Over max transaction limit
            
        }


        // Compliance and safety checks
        require(from != address(0), "E22"); // Not a valid BSC wallet address
        require(to != address(0), "E23"); // Not a valid BSC wallet address
        require(amount > 0, "E24"); // Amount must be greater than 0


        if (!takeFee){
            takeFee = true;
        }


        // Check if fee processing is possible
        if( _isPair[to] && !processingFees && autoFeeProcessing) {

            // Check that enough transactions have passed since last swap
            if(swapCounter >= swapTrigger && (_SwapFeeTotal_Buy + _SwapFeeTotal_Sell > 0)){

                // Check number of tokens on contract
                uint256 contractTokens = balanceOf(address(this));

                // Only trigger fee processing if there are tokens to swap!
                if (contractTokens > 0){

                    // Remove fee on sell that triggers fee processing
                    takeFee = false;

                    // Limit number of tokens that can be swapped 
                    if (contractTokens <= max_Tran){

                        swapAndLiquify (contractTokens);
                        
                        } else {
                        
                        swapAndLiquify (max_Tran);
                        
                    }
                }
            }  
        }


    // Remove transaction if either wallet is fee exempt, or during wallet to wallet transfers
    if(_isExcludedFromFee[from] || _isExcludedFromFee[to] || (freeWalletTransfers && !_isPair[to] && !_isPair[from])){
        takeFee = false;
    }

    _tokenTransfer(from, to, amount, takeFee);

    }


    /*
    
    ------------
    PROCESS FEES
    ------------

    */

    function swapAndLiquify(uint256 Tokens) private {

        // Lock 
        processingFees = true;  

        uint256 _FeesTotal      = _SwapFeeTotal_Buy + _SwapFeeTotal_Sell;
        uint256 LP_Tokens       = Tokens * (_Fee__Buy_Liquidity + _Fee__Sell_Liquidity) / _FeesTotal / 2;
        uint256 Swap_Tokens     = Tokens - LP_Tokens;

        // Swap tokens for BNB
        uint256 contract_BNB    = address(this).balance;
        swapTokensForBNB(Swap_Tokens);
        uint256 returned_BNB    = address(this).balance - contract_BNB;

        // Double fees instead of halving LP fee to prevent rounding errors if fee is an odd number
        uint256 fee_Split = _FeesTotal * 2 - (_Fee__Buy_Liquidity + _Fee__Sell_Liquidity);

        // Calculate the BNB values for each fee (excluding BNB wallet)
        uint256 BNB_Liquidity   = returned_BNB * (_Fee__Buy_Liquidity + _Fee__Sell_Liquidity)    / fee_Split;
        uint256 BNB_Charity     = returned_BNB * (_Fee__Buy_Charity   + _Fee__Sell_Charity)  * 2 / fee_Split;

        // Add liquidity 
        if (LP_Tokens >= 1){ // Cheaper gas than > 0

            addLiquidity(LP_Tokens, BNB_Liquidity);
            emit SwapAndLiquify(LP_Tokens, BNB_Liquidity, LP_Tokens);
        }   

        // Take developer fee
        if(BNB_Charity >= 1){ // Cheaper gas than > 0

            send_BNB(Wallet_Charity, BNB_Charity);
        
        }

        
        // Flush remaining BNB to Marketing wallet
        contract_BNB = address(this).balance;

        if(contract_BNB >= 1){ // Cheaper gas than > 0

            send_BNB(Wallet_Marketing, contract_BNB);
        }

        // Reset transaction counter (reset to 1 not 0 to save gas)
        swapCounter = 1;

        // Unlock
        processingFees = false;
    }

    // Swap tokens for BNB
    function swapTokensForBNB(uint256 tokenAmount) private {

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

    // Add liquidity and send Cake LP tokens to liquidity collection wallet
    function addLiquidity(uint256 tokenAmount, uint256 BNBAmount) private {

        _approve(address(this), address(uniswapV2Router), tokenAmount);
        uniswapV2Router.addLiquidityETH{value: BNBAmount}(
            address(this),
            tokenAmount,
            0, 
            0,
            Wallet_Liquidity, 
            block.timestamp
        );
    } 

    /*
    
    ----------------------------------
    TRANSFER TOKENS AND CALCULATE FEES
    ----------------------------------

    */


    uint256 private rAmount;

    uint256 private tTokens;
    uint256 private tReflect;
    uint256 private tSwapFeeTotal;
    uint256 private tTransferAmount;

    uint256 private rTokens;
    uint256 private rReflect;
    uint256 private rSwapFeeTotal;
    uint256 private rTransferAmount;

    

    // Transfer Tokens and Calculate Fees
    function _tokenTransfer(address sender, address recipient, uint256 tAmount, bool Fee) private {

        
        if (Fee){

            if(_isPair[recipient]){

                // Sell fees
                tTokens         = tAmount * _Fee__Sell_Tokens     / 100;
                tReflect        = tAmount * _Fee__Sell_Reflection / 100;
                tSwapFeeTotal   = tAmount * _SwapFeeTotal_Sell    / 100;

            } else {

                // Buy fees
                tTokens         = tAmount * _Fee__Buy_Tokens      / 100;
                tReflect        = tAmount * _Fee__Buy_Reflection  / 100;
                tSwapFeeTotal   = tAmount * _SwapFeeTotal_Buy     / 100;

            }

        } else {

                // No fees
                tTokens         = 0;
                tReflect        = 0;
                tSwapFeeTotal   = 0;

        }

        // Calculate reflected fees for RFI
        uint256 RFI     = _getRate(); 

        rAmount         = tAmount       * RFI;
        rTokens         = tTokens       * RFI;
        rReflect        = tReflect      * RFI;
        rSwapFeeTotal   = tSwapFeeTotal * RFI;

        tTransferAmount = tAmount - (tTokens + tReflect + tSwapFeeTotal);
        rTransferAmount = rAmount - (rTokens + rReflect + rSwapFeeTotal);

        
        // Swap tokens based on RFI status of sender and recipient
        if (_isExcludedFromRewards[sender] && !_isExcludedFromRewards[recipient]) {

            _tOwned[sender] -= tAmount;
            _rOwned[sender] -= rAmount;

            _rOwned[recipient] += rTransferAmount;

            emit Transfer(sender, recipient, tTransferAmount);

        } else if (!_isExcludedFromRewards[sender] && _isExcludedFromRewards[recipient]) {

            _rOwned[sender] -= rAmount;

            _tOwned[recipient] += tTransferAmount;
            _rOwned[recipient] += rTransferAmount;

            emit Transfer(sender, recipient, tTransferAmount);

        } else if (!_isExcludedFromRewards[sender] && !_isExcludedFromRewards[recipient]) {

            _rOwned[sender] -= rAmount;

            _rOwned[recipient] += rTransferAmount;

            emit Transfer(sender, recipient, tTransferAmount);

        } else if (_isExcludedFromRewards[sender] && _isExcludedFromRewards[recipient]) {

            _tOwned[sender] -= tAmount;
            _rOwned[sender] -= rAmount;

            _tOwned[recipient] += tTransferAmount;
            _rOwned[recipient] += rTransferAmount;

                

            emit Transfer(sender, recipient, tTransferAmount);

        } else {

            _rOwned[sender] -= rAmount;

            _rOwned[recipient] += rTransferAmount;

            emit Transfer(sender, recipient, tTransferAmount);

        }


        // Take reflections
        if(tReflect > 0){ 

            _rTotal -= rReflect;
            _tFeeTotal += tReflect;
        }

        // Take tokens
        if(tTokens > 0){ 

            _rOwned[Wallet_Tokens] += rTokens;
            if(_isExcludedFromRewards[Wallet_Tokens]){_tOwned[Wallet_Tokens] += tTokens;}
            emit Transfer(sender, Wallet_Tokens, tTokens);

        }

        // Take fees that require processing during swap and liquify
        if(tSwapFeeTotal > 0){ 

            _rOwned[address(this)] += rSwapFeeTotal;
            if(_isExcludedFromRewards[address(this)]){_tOwned[address(this)] += tSwapFeeTotal;}
            emit Transfer(sender, address(this), tSwapFeeTotal);

            // Increase the transaction counter
            unchecked{swapCounter++;}
                
        }

    }


   

    // This function is required so that the contract can receive BNB during fee processing
    receive() external payable {}




}



/*

    Custom Contract by Gen 

    Website: https://TokensByGen.com
    Telegram: https://t.me/GenTokens_GEN

    Created solely for use with BONYTA (BONYTA) Token
    This contract is not open source - Can not be used or forked without permission.

*/