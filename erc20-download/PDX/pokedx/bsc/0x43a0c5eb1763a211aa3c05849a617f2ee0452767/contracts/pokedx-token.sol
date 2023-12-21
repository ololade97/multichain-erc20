//SPDX-License-Identifier: MIT
/**
 * 
 *
 * author: 0xSharp, PokeDX <cryptosharp91@gmail.com>
 * discord: https://discord.gg/hfrT7fK4
 * telegram: https://t.me/dextalks
 * website: https://pokedx.app
 * twitter: https://twitter.com/pokedxapp
 * PokeDX v1.0
 *
 * This contract is inspired by and in part a rewrite a of reflect.finance and Safemoon, that aims to:
 * - fix a majority of the issues reported in the Certik Safemoon audit (e.g. SSL-03)
 *      https://www.certik.org/projects/safemoon
 * - Improve the reflection mechanism 
 * - exclude burn wallet from reflection
 * - time-lock lp tokens from auto lp
 * - Add flexibility to the contract for future governance compatibility
 * - make it easier to maintain the code and develop it further
 * - remove redundant code
 * - optimize gas
 *
 *
 *    __/\\\\\\\\\\\\\___        _______/\\\\\______        __/\\\________/\\\_        __/\\\\\\\\\\\\\\\_        __/\\\\\\\\\\\\____        __/\\\_______/\\\_
 *     _\/\\\/////////\\\_        _____/\\\///\\\____        _\/\\\_____/\\\//__        _\/\\\///////////__        _\/\\\////////\\\__        _\///\\\___/\\\/__
 *      _\/\\\_______\/\\\_        ___/\\\/__\///\\\__        _\/\\\__/\\\//_____        _\/\\\_____________        _\/\\\______\//\\\_        ___\///\\\\\\/____
 *       _\/\\\\\\\\\\\\\/__        __/\\\______\//\\\_        _\/\\\\\\//\\\_____        _\/\\\\\\\\\\\_____        _\/\\\_______\/\\\_        _____\//\\\\______
 *        _\/\\\/////////____        _\/\\\_______\/\\\_        _\/\\\//_\//\\\____        _\/\\\///////______        _\/\\\_______\/\\\_        ______\/\\\\______
 *         _\/\\\_____________        _\//\\\______/\\\__        _\/\\\____\//\\\___        _\/\\\_____________        _\/\\\_______\/\\\_        ______/\\\\\\_____
 *          _\/\\\_____________        __\///\\\__/\\\____        _\/\\\_____\//\\\__        _\/\\\_____________        _\/\\\_______/\\\__        ____/\\\////\\\___
 *           _\/\\\_____________        ____\///\\\\\/_____        _\/\\\______\//\\\_        _\/\\\\\\\\\\\\\\\_        _\/\\\\\\\\\\\\/___        __/\\\/___\///\\\_
 *            _\///______________        ______\/////_______        _\///________\///__        _\///////////////__        _\////////////_____        _\///_______\///__
*
* SPDX-License-Identifier: MIT
*/

pragma solidity ^0.8.7;

import "./pokedx-imports.sol";

abstract contract Tokenomics {

    // --------------------- Token Settings ------------------- //

    string internal constant NAME = "PokeDX";
    string internal constant SYMBOL = "PDX";

    uint16 internal constant FEES_DIVISOR = 10**3;
    uint8 internal constant DECIMALS = 9;
    uint256 internal constant ZEROES = 10**DECIMALS;

    uint256 private constant MAX = ~uint256(0);
    uint256 internal constant TOTAL_SUPPLY = 30000000 * ZEROES;
    uint256 internal _reflectedSupply = (MAX - (MAX % TOTAL_SUPPLY));

    /**
     * @dev Set the maximum transaction amount allowed in a transfer.
     */
    uint256 internal constant maxTransactionAmount = TOTAL_SUPPLY / 200; // 0.5% of the total supply(150,000)

    /**
     * @dev Set the number of tokens to swap and add to liquidity.
     *
     * Whenever the contract's balance reaches 30,000 PDX the swap & liquify will be
     * executed in the very next transfer.
     *
     */
    uint256 internal constant numberOfTokensToSwapToLiquidity =
        TOTAL_SUPPLY / 1000; // 0.1% of the total supply

    // --------------------- Fees Settings ------------------- //

    address internal burnAddress = 0x000000000000000000000000000000000000dEaD;

    enum FeeType {
        Liquidity,
        Rfi,
        Burn
    }
    struct Fee {
        uint256 position;
        FeeType name;
        uint256 value;
        address recipient;
        uint256 total;
    }

    Fee[] internal fees;
    uint256 public sumOfFees;

    constructor() {
        _addFees();
    }

    function _addFee(
        uint256 position,
        FeeType name,
        uint256 value,
        address recipient
    ) private {
        fees.push(Fee(position, name, value, recipient, 0));
        sumOfFees += value;
    }

    function _addFees() private {
        /**
         * The value of fees is given in part per 1000 (based on the value of FEES_DIVISOR),
         * e.g. for 5% use 50, for 3.5% use 35, etc.
         */
        _addFee(1,FeeType.Rfi, 20, address(this));
        _addFee(2,FeeType.Liquidity, 20, address(this));
        _addFee(3,FeeType.Burn, 0, burnAddress );
    }

    function _getFeesCount() internal view returns (uint256) {
        return fees.length;
    }

    function _getFeeStruct(uint256 index) private view returns (Fee storage) {
        require(
            index >= 0 && index < fees.length,
            "FeesSettings._getFeeStruct: Fee index out of bounds"
        );
        return fees[index];
    }

    function _getFee(uint256 index)
        internal
        view
        returns (
            uint256,
            FeeType,
            uint256,
            address,
            uint256
        )
    {
        Fee memory fee = _getFeeStruct(index);
        return (fee.position,fee.name, fee.value, fee.recipient, fee.total);
    }

    function _addFeeCollectedAmount(uint256 index, uint256 amount) internal {
        Fee storage fee = _getFeeStruct(index);
        fee.total = fee.total + amount;
    }

    // function getCollectedFeeTotal(uint256 index) external view returns (uint256){
    function getCollectedFeeTotal(uint256 index)
        internal
        view
        returns (uint256)
    {
        Fee memory fee = _getFeeStruct(index);
        return fee.total;
    }


}

//////////////////////////////////////////////////////////////////////////////////////////
 ///////////////////////////////BaseRfiToken START HERE////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////

abstract contract BaseRfiToken is
    IERC20,
    IERC20Metadata,
    Ownable,
    Pausable,
    Tokenomics
{
    using Address for address;
    
    mapping(address => uint256) internal _reflectedBalances;
    mapping(address => uint256) internal _balances;
    mapping(address => mapping(address => uint256)) internal _allowances;

    mapping(address => bool) internal _isExcludedFromFee;
    mapping(address => bool) internal _isExcludedFromRewards;
    address[] private _excluded;
    bool private _paused;

    constructor() {
        _reflectedBalances[owner()] = _reflectedSupply;

        // exclude owner and this contract from fee
        _isExcludedFromFee[owner()] = true;
        _isExcludedFromFee[address(this)] = true;

        // exclude the owner and this contract from rewards
        _exclude(owner());
        _exclude(address(this));

        emit Transfer(address(0), owner(), TOTAL_SUPPLY);
    }

    /** Functions required by IERC20Metadat **/
    function name() external pure override returns (string memory) {
        return NAME;
    }

    function symbol() external pure override returns (string memory) {
        return SYMBOL;
    }

    function decimals() external pure override returns (uint8) {
        return DECIMALS;
    }

    /** Functions required by IERC20Metadat - END **/
    /** Functions required by IERC20 **/
    function totalSupply() external pure override returns (uint256) {
        return TOTAL_SUPPLY;
    }

    function balanceOf(address account) public view override returns (uint256) {
        if (_isExcludedFromRewards[account]) return _balances[account];
        return tokenFromReflection(_reflectedBalances[account]);
    }

    function transfer(address recipient, uint256 amount)
        external
        override
        returns (bool)
    {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address owner, address spender)
        external
        view
        override
        returns (uint256)
    {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount)
        external
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
    ) external override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(
            sender,
            _msgSender(),
            _allowances[sender][_msgSender()] -
                amount
        );
        return true;
    }

    /** Functions required by IERC20 - END **/

    /**
     * @dev this is really a "soft" burn (total supply is not reduced). RFI holders
     * get two benefits from burning tokens:
     *
     * 1) Tokens in the burn address increase the % of tokens held by holders not
     *    excluded from rewards (assuming the burn address is excluded)
     * 2) Tokens in the burn address cannot be sold (which in turn draing the
     *    liquidity pool)
     *
     *
     * In RFI holders already get % of each transaction so the value of their tokens
     * increases (in a way). Therefore there is really no need to do a "hard" burn
     * (reduce the total supply). What matters (in RFI) is to make sure that a large
     * amount of tokens cannot be sold = draining the liquidity pool = lowering the
     * value of tokens holders own. For this purpose, transfering tokens to a (vanity)
     * burn address is the most appropriate way to "burn".
     *
     * There is an extra check placed into the `transfer` function to make sure the
     * burn address cannot withdraw the tokens is has (although the chance of someone
     * having/finding the private key is virtually zero).
     */
    function burn(uint256 amount) external {
        address sender = _msgSender();
        require(
            sender != address(0),
            "BaseRfiToken: burn from the zero address"
        );
        require(
            sender != address(burnAddress),
            "BaseRfiToken: burn from the burn address"
        );

        uint256 balance = balanceOf(sender);
        require(balance >= amount, "BaseRfiToken: burn amount exceeds balance");

        uint256 reflectedAmount = amount * _getCurrentRate();

        // remove the amount from the sender's balance first
        _reflectedBalances[sender] = _reflectedBalances[sender] -
            reflectedAmount;
        if (_isExcludedFromRewards[sender])
            _balances[sender] = _balances[sender] - amount;

        _burnTokens(sender, amount, reflectedAmount);
    }

    /**
     * @dev "Soft" burns the specified amount of tokens by sending them
     * to the burn address
     */
    function _burnTokens(
        address sender,
        uint256 tBurn,
        uint256 rBurn
    ) internal {
        /**
         * @dev Do not reduce _totalSupply and/or _reflectedSupply. (soft) burning by sending
         * tokens to the burn address (which should be excluded from rewards) is sufficient
         * in RFI
         */
        _reflectedBalances[burnAddress] = _reflectedBalances[burnAddress] +
            rBurn;
        if (_isExcludedFromRewards[burnAddress])
            _balances[burnAddress] = _balances[burnAddress] + tBurn;

        /**
         * @dev Emit the event so that the burn address balance is updated (on bscscan)
         */
        emit Transfer(sender, burnAddress, tBurn);
    }

    function increaseAllowance(address spender, uint256 addedValue)
        public
        virtual
        returns (bool)
    {
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender] + addedValue
        );
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue)
        public
        virtual
        returns (bool)
    {
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender] -
                subtractedValue
        );
        return true;
    }

    function isExcludedFromReward(address account)
        external
        view
        returns (bool)
    {
        return _isExcludedFromRewards[account];
    }

    /**
     * @dev Calculates and returns the reflected amount for the given amount with or without
     * the transfer fees (deductTransferFee true/false)
     */
    function reflectionFromToken(uint256 tAmount, bool deductTransferFee)
        external
        view
        returns (uint256)
    {
        require(tAmount <= TOTAL_SUPPLY, "Amount must be less than supply");
        if (!deductTransferFee) {
            (uint256 rAmount, , , , ) = _getValues(tAmount, 0);
            return rAmount;
        } else {
            (, uint256 rTransferAmount, , , ) = _getValues(
                tAmount,
                _getSumOfFees()
            );
            return rTransferAmount;
        }
    }

    /**
     * @dev Calculates and returns the amount of tokens corresponding to the given reflected amount.
     */
    function tokenFromReflection(uint256 rAmount)
        internal
        view
        returns (uint256)
    {
        require(
            rAmount <= _reflectedSupply,
            "Amount must be less than total reflections"
        );
        uint256 currentRate = _getCurrentRate();
        return rAmount / currentRate;
    }

    function excludeFromReward(address account) external onlyOwner {
        require(!_isExcludedFromRewards[account], "Account is not included");
        _exclude(account);
    }

    function _exclude(address account) internal {
        if (_reflectedBalances[account] > 0) {
            _balances[account] = tokenFromReflection(
                _reflectedBalances[account]
            );
        }
        _isExcludedFromRewards[account] = true;
        _excluded.push(account);
    }

    function includeInReward(address account) external onlyOwner {
        require(_isExcludedFromRewards[account], "Account is not excluded");
        for (uint256 i = 0; i < _excluded.length; i++) {
            if (_excluded[i] == account) {
                _excluded[i] = _excluded[_excluded.length - 1];
                _balances[account] = 0;
                _isExcludedFromRewards[account] = false;
                _excluded.pop();
                break;
            }
        }
    }

    function setExcludedFromFee(address account, bool value)
        external
        onlyOwner
    {
        _isExcludedFromFee[account] = value;
    }

    function isExcludedFromFee(address account) public view returns (bool) {
        return _isExcludedFromFee[account];
    }

    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal {
        require(
            owner != address(0),
            "BaseRfiToken: approve from the zero address"
        );
        require(
            spender != address(0),
            "BaseRfiToken: approve to the zero address"
        );

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    /**
     */
    function _isUnlimitedSender(address account) internal view returns (bool) {
        // the owner should be the only whitelisted sender
        return (account == owner());
    }

    /**
     */
    function _isUnlimitedRecipient(address account)
        internal
        view
        returns (bool)
    {
        // the owner should be a white-listed recipient
        // and anyone should be able to burn as many tokens as
        // he/she wants
        return (account == owner() || account == burnAddress);
    }

    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) private {
        require(
            sender != address(0),
            "BaseRfiToken: transfer from the zero address"
        );
        require(
            recipient != address(0),
            "BaseRfiToken: transfer to the zero address"
        );
        require(
            sender != address(burnAddress),
            "BaseRfiToken: transfer from the burn address"
        );
        require(amount > 0, "Transfer amount must be greater than zero");

        // indicates whether or not feee should be deducted from the transfer
        bool takeFee = true;

        if (paused()) {
            takeFee = false;
        } else {
            /**
             * Check the amount is within the max allowed limit as long as a
             * unlimited sender/recepient is not involved in the transaction
             */
            if (
                amount > maxTransactionAmount &&
                !_isUnlimitedSender(sender) &&
                !_isUnlimitedRecipient(recipient)
            ) {
                revert("Transfer amount exceeds the maxTxAmount.");
            }
        }

        // if any account belongs to _isExcludedFromFee account then remove the fee
        if (_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]) {
            takeFee = false;
        }

        _beforeTokenTransfer(sender, recipient, amount, takeFee);
        _transferTokens(sender, recipient, amount, takeFee);
    }

    function _transferTokens(
        address sender,
        address recipient,
        uint256 amount,
        bool takeFee
    ) private {
        /**
         * We don't need to know anything about the individual fees here
         * (like Safemoon does with `_getValues`). All that is required
         * for the transfer is the sum of all fees to calculate the % of the total
         * transaction amount which should be transferred to the recipient.
         *
         * The `_takeFees` call will/should take care of the individual fees
         */
        uint256 sumOfFees = _getSumOfFees();
        if (!takeFee) {
            sumOfFees = 0;
        }

        (
            uint256 rAmount,
            uint256 rTransferAmount,
            uint256 tAmount,
            uint256 tTransferAmount,
            uint256 currentRate
        ) = _getValues(amount, sumOfFees);

        /**
         * Sender's and Recipient's reflected balances must be always updated regardless of
         * whether they are excluded from rewards or not.
         */
        _reflectedBalances[sender] = _reflectedBalances[sender] - rAmount;
        _reflectedBalances[recipient] = _reflectedBalances[recipient] +
            rTransferAmount;

        /**
         * Update the true/nominal balances for excluded accounts
         */
        if (_isExcludedFromRewards[sender]) {
            _balances[sender] = _balances[sender] - tAmount;
        }
        if (_isExcludedFromRewards[recipient]) {
            _balances[recipient] = _balances[recipient] + tTransferAmount;
        }

        _takeFees(amount, currentRate, sumOfFees);
        emit Transfer(sender, recipient, tTransferAmount);
    }

    function _takeFees(
        uint256 amount,
        uint256 currentRate,
        uint256 sumOfFees
    ) private {
        if (sumOfFees > 0 && !paused()) {
            _takeTransactionFees(amount, currentRate);
        }
    }

    function _getValues(uint256 tAmount, uint256 feesSum)
        internal
        view
        returns (
            uint256,
            uint256,
            uint256,
            uint256,
            uint256
        )
    {
        uint256 tTotalFees = tAmount * feesSum / FEES_DIVISOR;
        uint256 tTransferAmount = tAmount - tTotalFees;
        uint256 currentRate = _getCurrentRate();
        uint256 rAmount = tAmount * currentRate;
        uint256 rTotalFees = tTotalFees * currentRate;
        uint256 rTransferAmount = rAmount - rTotalFees;

        return (
            rAmount,
            rTransferAmount,
            tAmount,
            tTransferAmount,
            currentRate
        );
    }

    function _getCurrentRate() internal view returns (uint256) {
        (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
        return rSupply / tSupply;
    }

    function _getCurrentSupply() internal view returns (uint256, uint256) {
        uint256 rSupply = _reflectedSupply;
        uint256 tSupply = TOTAL_SUPPLY;

        /**
         * The code below removes balances of addresses excluded from rewards from
         * rSupply and tSupply, which effectively increases the % of transaction fees
         * delivered to non-excluded holders
         */
        for (uint256 i = 0; i < _excluded.length; i++) {
            if (
                _reflectedBalances[_excluded[i]] > rSupply ||
                _balances[_excluded[i]] > tSupply
            ) return (_reflectedSupply, TOTAL_SUPPLY);
            rSupply = rSupply - _reflectedBalances[_excluded[i]];
            tSupply = tSupply - _balances[_excluded[i]];
        }
        if (tSupply == 0 || rSupply < _reflectedSupply / TOTAL_SUPPLY)
            return (_reflectedSupply, TOTAL_SUPPLY);
        return (rSupply, tSupply);
    }

    /**
     * @dev Hook that is called before any transfer of tokens.
     */
    function _beforeTokenTransfer(
        address sender,
        address recipient,
        uint256 amount,
        bool takeFee
    ) internal virtual;

    /**
     * @dev Returns the total sum of fees to be processed in each transaction.
     *
     * To separate concerns this contract (class) will take care of ONLY handling RFI, i.e.
     * changing the rates and updating the holder's balance (via `_redistribute`).
     * It is the responsibility of the dev/user to handle all other fees and taxes
     * in the appropriate contracts (classes).
     */
    function _getSumOfFees()
        internal
        view
        virtual
        returns (uint256);

    /**
     * @dev A delegate which should return true if the given address is the V2 Pair and false otherwise
     */
    function _isV2Pair(address account) internal view virtual returns (bool);

    /**
     * @dev Redistributes the specified amount among the current holders via the reflect.finance
     * algorithm, i.e. by updating the _reflectedSupply (_rSupply) which ultimately adjusts the
     * current rate used by `tokenFromReflection` and, in turn, the value returns from `balanceOf`.
     * This is the bit of clever math which allows rfi to redistribute the fee without
     * having to iterate through all holders.
     *
     * Visit our discord at https://discord.gg/dAmr6eUTpM
     */
    function _redistribute(
        uint256 amount,
        uint256 currentRate,
        uint256 fee,
        uint256 index
    ) internal {
        uint256 tFee = amount * fee / FEES_DIVISOR;
        uint256 rFee = tFee * currentRate;

        _reflectedSupply = _reflectedSupply - rFee;
        _addFeeCollectedAmount(index, tFee);
    }

    /**
     * @dev Hook that is called before the `Transfer` event is emitted if fees are enabled for the transfer
     */
    function _takeTransactionFees(uint256 amount, uint256 currentRate)
        internal
        virtual;

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }
}


//////////////////////////////////////////////////////////////////////////////////////////
 ///////////////////////////////Liquifier START HERE////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////

abstract contract Liquifier is Ownable {

    uint256 private withdrawableBalance;
    
    address private _routerAddress;

    IPancakeV2Router internal _router;
    address internal _pair;

    bool private inSwapAndLiquify;
    bool private swapAndLiquifyEnabled = true;

    uint256 private maxTransactionAmount;
    uint256 private numberOfTokensToSwapToLiquidity;

    address private LPReceiver;

    modifier lockTheSwap() {
        inSwapAndLiquify = true;
        _;
        inSwapAndLiquify = false;
    }

    event RouterSet(address indexed router);
    event SwapAndLiquify(
        uint256 tokensSwapped,
        uint256 ethReceived,
        uint256 tokensIntoLiquidity
    );
    event SwapAndLiquifyEnabledUpdated(bool enabled);
    event LiquidityAdded(
        uint256 tokenAmountSent,
        uint256 ethAmountSent,
        uint256 liquidity
    );
    event LPReceiverChanged(address LPReceiver);
    event NumberOfTokensToSwapToLiquidityChanged(uint256 tokenAmount);

    receive() external payable {}

    function _setNumberOfTokensToSwapToLiquidity(uint256 tokenAmount) external onlyOwner{
        numberOfTokensToSwapToLiquidity = tokenAmount;
        emit NumberOfTokensToSwapToLiquidityChanged(tokenAmount);

    }
    function showNumberOfTokensToSwapToLiquidity() external view returns(uint256) {
        return numberOfTokensToSwapToLiquidity;
    }

    function initializeLiquiditySwapper(
        address env,
        uint256 maxTx,
        uint256 liquifyAmount
    ) internal {
            _setRouterAddress(env);
        

        maxTransactionAmount = maxTx;
        numberOfTokensToSwapToLiquidity = liquifyAmount;
    }

    /**
     * NOTE: passing the `contractTokenBalance` here is preferred to creating `balanceOfDelegate`
     */
    function liquify(uint256 contractTokenBalance, address sender) internal {
        if (contractTokenBalance >= maxTransactionAmount)
            contractTokenBalance = maxTransactionAmount;

        bool isOverRequiredTokenBalance = (contractTokenBalance >=
            numberOfTokensToSwapToLiquidity);

        /**
         * - first check if the contract has collected enough tokens to swap and liquify
         * - then check swap and liquify is enabled
         * - then make sure not to get caught in a circular liquidity event
         * - finally, don't swap & liquify if the sender is the uniswap pair
         */
        if (
            isOverRequiredTokenBalance &&
            swapAndLiquifyEnabled &&
            !inSwapAndLiquify &&
            (sender != _pair)
        ) {
            // TODO check if the `(sender != _pair)` is necessary because that basically
            // stops swap and liquify for all "buy" transactions
            _swapAndLiquify(contractTokenBalance);
        }
    }

    /**
     * @dev sets the router address and created the router, factory pair to enable
     * swapping and liquifying (contract) tokens
     */
    function _setRouterAddress(address router) private {
        IPancakeV2Router _newPancakeRouter = IPancakeV2Router(router);
        _pair = IPancakeV2Factory(_newPancakeRouter.factory()).createPair(
            address(this),
            _newPancakeRouter.WETH()
        );
        _router = _newPancakeRouter;
        emit RouterSet(router);
    }

    function _swapAndLiquify(uint256 amount) private lockTheSwap {
        // split the contract balance into halves
        uint256 half = amount / 2;
        uint256 otherHalf = amount - half;

        // capture the contract's current ETH balance.
        // this is so that we can capture exactly the amount of ETH that the
        // swap creates, and not make the liquidity event include any ETH that
        // has been manually sent to the contract
        uint256 initialBalance = address(this).balance;

        // swap tokens for ETH
        _swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered

        // how much ETH did we just swap into?
        uint256 newBalance = address(this).balance - initialBalance;

        // add liquidity to uniswap
        _addLiquidity(otherHalf, newBalance);

        emit SwapAndLiquify(half, newBalance, otherHalf);
    }

    function _swapTokensForEth(uint256 tokenAmount) private {
        // generate the uniswap pair path of token -> weth
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = _router.WETH();

        _approveDelegate(address(this), address(_router), tokenAmount);

        // make the swap
        _router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            // The minimum amount of output tokens that must be received for the transaction not to revert.
            // 0 = accept any amount (slippage is inevitable)
            0,
            path,
            address(this),
            block.timestamp
        );
    }

    function setLPReceiver(address receiver) external onlyOwner{
        LPReceiver = receiver;
        emit LPReceiverChanged(LPReceiver);
    }
    function showLPReceiver() external view returns(address){
        return LPReceiver;
    }

    

    function _addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
        // approve token transfer to cover all possible scenarios
        _approveDelegate(address(this), address(_router), tokenAmount);

        // add the liquidity
        (uint256 tokenAmountSent, uint256 ethAmountSent, uint256 liquidity) = _router
            .addLiquidityETH{value: ethAmount}(
            address(this),
            tokenAmount,
            // Bounds the extent to which the WETH/token price can go up before the transaction reverts.
            // Must be <= amountTokenDesired; 0 = accept any amount (slippage is inevitable)
            0,
            // Bounds the extent to which the token/WETH price can go up before the transaction reverts.
            // 0 = accept any amount (slippage is inevitable)
            0,
            // this is a centralized risk if the owner's account is ever compromised (see Certik SSL-04)
            // owner(),
            LPReceiver,
            block.timestamp
        );

        // fix the forever locked BNBs as per the certik's audit
        /**
         * The swapAndLiquify function converts half of the contractTokenBalance SafeMoon tokens to BNB.
         * For every swapAndLiquify function call, a small amount of BNB remains in the contract.
         * This amount grows over time with the swapAndLiquify function being called throughout the life
         * of the contract. The Safemoon contract does not contain a method to withdraw these funds,
         * and the BNB will be locked in the Safemoon contract forever.
         */
        withdrawableBalance = address(this).balance;
        emit LiquidityAdded(tokenAmountSent, ethAmountSent, liquidity);
    }

    /**
     * @dev Sets the uniswapV2 pair (router & factory) for swapping and liquifying tokens
     */
    function setRouterAddress(address router) external onlyOwner {
        _setRouterAddress(router);
    }

    /**
     * @dev Sends the swap and liquify flag to the provided value. If set to `false` tokens collected in the contract will
     * NOT be converted into liquidity.
     */
    function setSwapAndLiquifyEnabled(bool enabled) external onlyOwner {
        swapAndLiquifyEnabled = enabled;
        emit SwapAndLiquifyEnabledUpdated(swapAndLiquifyEnabled);
    }

    /**
     * @dev The owner can withdraw ETH(BNB) collected in the contract from `swapAndLiquify`
     * or if someone (accidentally) sends ETH/BNB directly to the contract.
     *
     * Note: This addresses the contract flaw pointed out in the Certik Audit of Safemoon (SSL-03):
     *
     * The swapAndLiquify function converts half of the contractTokenBalance SafeMoon tokens to BNB.
     * For every swapAndLiquify function call, a small amount of BNB remains in the contract.
     * This amount grows over time with the swapAndLiquify function being called
     * throughout the life of the contract. The Safemoon contract does not contain a method
     * to withdraw these funds, and the BNB will be locked in the Safemoon contract forever.
     * https://www.certik.org/projects/safemoon
     */
    function withdrawLockedBNB(address payable recipient) external onlyOwner {
        require(
            recipient != address(0),
            "Cannot withdraw the BNB balance to the zero address"
        );
        require(
            withdrawableBalance > 0,
            "The BNB balance must be greater than 0"
        );

        // prevent re-entrancy attacks
        uint256 amount = withdrawableBalance;
        withdrawableBalance = 0;
        recipient.transfer(amount);
    }

    /**
     * @dev Use this delegate instead of having (unnecessarily) extend `BaseRfiToken` to gained access
     * to the `_approve` function.
     */
    function _approveDelegate(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual;
}

//////////////////////////////////////////////////////////////////////////////////////////
 ///////////////////////////////PokeDX START HERE////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////

contract PokeDX is BaseRfiToken, Liquifier {

    event FeeIncreased(uint256 FeePosition, uint256 AddedValue, uint256 FeeTotal);
    event FeeDecreased(uint256 FeePosition, uint256 AddedValue, uint256 FeeTotal);


    constructor(address _env) { 
        initializeLiquiditySwapper(
            _env,
            maxTransactionAmount,
            numberOfTokensToSwapToLiquidity
        );

        // exclude the pair address from rewards - we don't want to redistribute
        // tx fees to these two; redistribution is only for holders, dah!
        _exclude(_pair);
        _exclude(burnAddress);
        _approve(owner(),address(_router), ~uint256(0));
    }

    function _isV2Pair(address account) internal view override returns (bool) {
        return (account == _pair);
    }

    function _getSumOfFees()
        internal
        view
        override
        returns (uint256)
    {
        return sumOfFees;
    }

    function _beforeTokenTransfer(
        address sender,
        address,
        uint256,
        bool
    ) internal override {
        if (!paused()) {
            uint256 contractTokenBalance = balanceOf(address(this));
            liquify(contractTokenBalance, sender);
        }
    }

    function _takeTransactionFees(uint256 amount, uint256 currentRate)
        internal
        override
    {
        if (paused()) {
            return;
        }

        uint256 feesCount = _getFeesCount();
        for (uint256 index = 0; index < feesCount; index++) {
            (,FeeType name, uint256 value, address recipient, ) = _getFee(index);
            // no need to check value < 0 as the value is uint (i.e. from 0 to 2^256-1)
            if (value == 0) continue;

            if (name == FeeType.Rfi) {
                _redistribute(amount, currentRate, value, index);
            } else if (name == FeeType.Burn) {
                _burn(amount, currentRate, value, index);
            } else {
                _takeFee(amount, currentRate, value, recipient, index);
            }
        }
    }

    function _burn(
        uint256 amount,
        uint256 currentRate,
        uint256 fee,
        uint256 index
    ) private {
        uint256 tBurn = amount *fee / FEES_DIVISOR;
        uint256 rBurn = tBurn * currentRate;

        _burnTokens(address(this), tBurn, rBurn);
        _addFeeCollectedAmount(index, tBurn);
    }

    function _takeFee(
        uint256 amount,
        uint256 currentRate,
        uint256 fee,
        address recipient,
        uint256 index
    ) private {
        uint256 tAmount = amount * fee / FEES_DIVISOR;
        uint256 rAmount = tAmount * currentRate;

        _reflectedBalances[recipient] = _reflectedBalances[recipient] +
            rAmount;
        if (_isExcludedFromRewards[recipient])
            _balances[recipient] = _balances[recipient] + tAmount;

        _addFeeCollectedAmount(index, tAmount);
    }


    function _approveDelegate(
        address owner,
        address spender,
        uint256 amount
    ) internal override {
        _approve(owner, spender, amount);
    }

    function showFee(uint256 index) external view returns(uint256,
            FeeType,
            uint256,
            address,
            uint256){
        return _getFee(index);
    }

    function increaseFee(uint256 index, uint256 addedValue ) external onlyOwner{
        require ((_getSumOfFees() + addedValue) <= 80, "Maximum 8% fee is allowed!" );
        uint256 _sumOfFees = sumOfFees;
        uint256 updatedSumOfFees = _sumOfFees + addedValue;
        sumOfFees = updatedSumOfFees;
        fees[index].value += addedValue;
        emit FeeIncreased(index,  addedValue,  sumOfFees);
    }
    function decreaseFee(uint256 index, uint256 subtractedValue ) external onlyOwner{
        require((_getSumOfFees() - subtractedValue ) >= 0, "Can't really go negative in there..." );
        uint256 _sumOfFees = sumOfFees;
        uint256 updatedSumOfFees = _sumOfFees - subtractedValue; 
        sumOfFees = updatedSumOfFees;
        fees[index].value -= subtractedValue;
        emit FeeDecreased( index,  subtractedValue,  sumOfFees);
        
    }

    
}
