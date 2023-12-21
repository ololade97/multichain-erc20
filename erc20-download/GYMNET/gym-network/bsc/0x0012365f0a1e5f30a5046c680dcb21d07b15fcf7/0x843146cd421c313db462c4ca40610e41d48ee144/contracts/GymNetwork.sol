// SPDX-License-Identifier: MITS

pragma solidity 0.8.15;
// pragma experimental ABIEncoderV2;
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "./interfaces/IPancakeRouter02.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/utils/SafeERC20Upgradeable.sol";

interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
}


interface ITaxCollector {
    function swapTokensForBNB() external returns (bool);

    function updateTaxationAmount(bool, uint96) external;
    function updateManagementTaxationAmount(uint96) external;
}

contract GymNetwork is OwnableUpgradeable, ReentrancyGuardUpgradeable {
    using SafeERC20Upgradeable for IERC20Upgradeable;
    /// @notice EIP-20 token name for this token
    string public constant name = "GYM NETWORK V2";

    /// @notice EIP-20 token symbol for this token
    string public constant symbol = "GYMNET";

    /// @notice EIP-20 token decimals for this token
    uint8 public constant decimals = 18;

    /// @notice Percent amount of tax for the token sell on dex
    uint8 public constant taxOnSell = 3;

    /// @notice Percent amount of tax for the token purchase on dex
    uint8 public constant taxOnPurchase = 0;

    /// @notice Max gas price allowed for GYM transaction
    uint256 public gasPriceLimit;

    /// @notice Period of 50% sell of limit (by default 24 hours)
    uint256 public limitPeriod;

    /// @notice Total number of tokens in circulation
    uint96 public constant MAX_SUPPLY = 600000000 ether;
    uint96 public totalSupply;
    uint96 public minted;

    /// @notice Address of GYM Treasury
    address public managementAddress;
    address public routerAddress;
    address public taxCollector;
    /// @dev Allowance amounts on behalf of others
    mapping(address => mapping(address => uint96)) internal allowances;

    /// @dev Official record of token balances for each account
    mapping(address => uint96) internal balances;

    /// @notice A record of each accounts delegate
    mapping(address => address) public delegates;

    /// @notice A record of each DEX account
    mapping(address => bool) public isDex;

    /// @notice A record of whitelisted addresses allowed to hold more than maxPerHolder
    mapping(address => bool) private _isLimitExcempt;

    /// @notice A record of addresses disallowed to withdraw more than 50% within period
    mapping(address => bool) private _isSellLimited;

    /// @notice A record of addresses that are not taxed during trades
    mapping(address => bool) private _dexTaxExcempt;

    /// @notice A record of blacklisted addresses
    mapping(address => bool) private _isBlackListed;

    /// @notice A switch which activates or deactivates sellLimit
    bool public sellLimitActive;
    bool public isTradingPaused;
    bool public autoSwapTax;

    /// @notice A checkpoint for marking number of votes from a given block
    struct Checkpoint {
        uint32 fromBlock;
        uint96 votes;
    }

    /// @notice A checkpoint for outgoing transaction
    struct User {
        uint96[] withdrawalAmounts;
        uint256[] withdrawalTimestamps;
    }

    /// @notice A record of account withdrawals
    mapping(address => User) private _withdrawals;

    /// @notice A record of votes checkpoints for each account, by index
    mapping(address => mapping(uint32 => Checkpoint)) public checkpoints;

    /// @notice The number of checkpoints for each account
    mapping(address => uint32) public numCheckpoints;

    /// @notice The EIP-712 typehash for the contract's domain
    bytes32 public constant DOMAIN_TYPEHASH =
        keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");

    /// @notice The EIP-712 typehash for the delegation struct used by the contract
    bytes32 public constant DELEGATION_TYPEHASH =
        keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");

    /// @notice A record of states for signing / validating signatures
    mapping(address => uint256) public nonces;
    /// WBNB and BUSD Token Pair address, element 0 = Address of WBNB Token, element 1= Address of GYMNET
    address[] public wbnbAndUSDTTokenArray;
    /// GYMNET and WBNB Token Pair address, element 0 = Address of GYMNET, element 1 = Address of WBNB Token,
    address[] public GymWBNBPair;
    /// @notice An event thats emitted when an account changes its delegate
    event DelegateChanged(
        address indexed delegator,
        address indexed fromDelegate,
        address indexed toDelegate
    );

    /// @notice An event thats emitted when a delegate account's vote balance changes
    event DelegateVotesChanged(
        address indexed delegate,
        uint256 previousBalance,
        uint256 newBalance
    );

    /// @notice The standard EIP-20 transfer event
    event Transfer(address indexed from, address indexed to, uint256 amount);

    /// @notice The standard EIP-20 approval event
    event Approval(address indexed owner, address indexed spender, uint256 amount);

    event SetLimitPeriod(uint256 limit);
    event SetDexAddress(address indexed _address, bool isDex);
    event SetTaxExcemptAddress(address indexed _address, bool isExcempt);
    event SetAutoSwapTax(bool _swap);
    event SetTaxCollectorAddress(address indexed _address);

    event SetSellLimitActive(bool _isActive);
    event SetGasPriceLimit(uint256 gasPrice);
    event SetPauseTrading(bool _isPaused);
    event SetPancakeRouterAddress(address indexed _address);
    event SetManagementAddress(address indexed _address);

    event WalletSellLimitExcempt(address indexed _address, bool isExcempt);
    event WalleHoldLimitExcempt(address indexed _address, bool isExcempt);

    /**
     * @notice Construct a new Gym Network
     */

    function initialize(
        address _managementAddress,
        address _routerAddress,
        address _taxCollectorAddress,
        address[] memory _wbnbAndUSDTTokenArray
    ) external initializer {
        isTradingPaused = true;
        autoSwapTax = false;
        managementAddress = _managementAddress;
        routerAddress = _routerAddress;
        taxCollector = _taxCollectorAddress;
        gasPriceLimit = 50000000000;
        limitPeriod = 86400;
        wbnbAndUSDTTokenArray = _wbnbAndUSDTTokenArray; // WBNB And USDT Token Addresses [WBNB,BUSD]
        GymWBNBPair = [address(this), _wbnbAndUSDTTokenArray[0]]; // GYMNET And WBNB Token Addresses [GYMNET,WBNB]
        _dexTaxExcempt[address(this)] = true;
        _dexTaxExcempt[routerAddress] = true;
        _dexTaxExcempt[taxCollector] = true;
        _isLimitExcempt[owner()] = true;
        __Ownable_init();
        __ReentrancyGuard_init();
    }

    /**
     * @notice Get the number of tokens `spender` is approved to spend on behalf of `account`
     * @param account The address of the account holding the funds
     * @param spender The address of the account spending the funds
     * @return The number of tokens approved
     */
    function allowance(address account, address spender) external view returns (uint256) {
        return allowances[account][spender];
    }

    /**
     * @notice Approve `spender` to transfer up to `amount` from `src`
     * @dev This will overwrite the approval amount for `spender`
     *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
     * @param spender The address of the account which may transfer tokens
     * @param rawAmount The number of tokens that are approved (2^256-1 means infinite)
     * @return Whether or not the approval succeeded
     */
    function approve(address spender, uint256 rawAmount) public returns (bool) {
        uint96 amount;
        if (rawAmount == type(uint256).max) {
            amount = type(uint96).max;
        } else {
            amount = safe96(rawAmount, "GymNet::approve: amount exceeds 96 bits");
        }

        allowances[msg.sender][spender] = amount;

        emit Approval(msg.sender, spender, amount);
        return true;
    }

    /**
     * @notice Get the number of tokens held by the `account`
     * @param account The address of the account to get the balance of
     * @return The number of tokens held
     */
    function balanceOf(address account) public view returns (uint256) {
        return balances[account];
    }

    /**
     * @notice Transfer `amount` tokens from `msg.sender` to `dst`
     * @param dst The address of the destination account
     * @param rawAmount The number of tokens to transfer
     * @return Whether or not the transfer succeeded
     */
    function transfer(address dst, uint256 rawAmount) external returns (bool) {
        uint96 amount = safe96(rawAmount, "GymNet::transfer: amount exceeds 96 bits");
        _transferTokens(msg.sender, dst, amount);
        return true;
    }

    /**
     * @notice Transfer `amount` tokens from `src` to `dst`
     * @param src The address of the source account
     * @param dst The address of the destination account
     * @param rawAmount The number of tokens to transfer
     * @return Whether or not the transfer succeeded
     */
    function transferFrom(
        address src,
        address dst,
        uint256 rawAmount
    ) external returns (bool) {
        address spender = msg.sender;
        uint96 spenderAllowance = allowances[src][spender];
        uint96 amount = safe96(rawAmount, "GymNet::approve: amount exceeds 96 bits");

        if (spender != src && spenderAllowance != type(uint96).max) {
            uint96 newAllowance = sub96(
                spenderAllowance,
                amount,
                "GymNet::transferFrom: transfer amount exceeds spender allowance"
            );
            allowances[src][spender] = newAllowance;

            emit Approval(src, spender, newAllowance);
        }

        _transferTokens(src, dst, amount);
        return true;
    }

    /**
     * @notice Gets the current votes balance for `account`
     * @param account The address to get votes balance
     * @return The number of current votes for `account`
     */
    function getCurrentVotes(address account) external view returns (uint96) {
        uint32 nCheckpoints = numCheckpoints[account];
        return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
    }

    /**
     * @notice Determine the prior number of votes for an account as of a block number
     * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
     * @param account The address of the account to check
     * @param blockNumber The block number to get the vote balance at
     * @return The number of votes the account had as of the given block
     */
    function getPriorVotes(address account, uint256 blockNumber) public view returns (uint96) {
        require(blockNumber < block.number, "GymNet::getPriorVotes: not yet determined");

        uint32 nCheckpoints = numCheckpoints[account];
        if (nCheckpoints == 0) {
            return 0;
        }

        // First check most recent balance
        if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
            return checkpoints[account][nCheckpoints - 1].votes;
        }

        // Next check implicit zero balance
        if (checkpoints[account][0].fromBlock > blockNumber) {
            return 0;
        }

        uint32 lower = 0;
        uint32 upper = nCheckpoints - 1;
        while (upper > lower) {
            uint32 center = upper - (upper - lower) / 2;
            // ceil, avoiding overflow
            Checkpoint memory cp = checkpoints[account][center];
            if (cp.fromBlock == blockNumber) {
                return cp.votes;
            } else if (cp.fromBlock < blockNumber) {
                lower = center;
            } else {
                upper = center - 1;
            }
        }
        return checkpoints[account][lower].votes;
    }

    /**
     * @dev Destroys `amount` tokens from `account`, reducing the total supply.
     */
    function burn(uint256 rawAmount) public {
        uint96 amount = safe96(rawAmount, "GymNet::approve: amount exceeds 96 bits");
        _burn(msg.sender, amount);
        _moveDelegates(delegates[msg.sender],address(0),amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`, deducting from the caller's
     * allowance.
     */
    function burnFrom(address account, uint256 rawAmount) public {
        uint96 amount = safe96(rawAmount, "GymNet::approve: amount exceeds 96 bits");
        uint96 currentAllowance = allowances[account][msg.sender];
        require(currentAllowance >= amount, "GymToken: burn amount exceeds allowance");
        allowances[account][msg.sender] = currentAllowance - amount;
        _burn(account, amount);
        _moveDelegates(delegates[account],address(0),amount);
    }

    /**
     * @notice Delegate votes from `msg.sender` to `delegatee`
     * @param delegatee The address to delegate votes to
     */
    function delegate(address delegatee) public {
        return _delegate(msg.sender, delegatee);
    }

    /**
     * @notice Delegates votes from signatory to `delegatee`
     * @param delegatee The address to delegate votes to
     * @param nonce The contract state required to match the signature
     * @param expiry The time at which to expire the signature
     * @param v The recovery byte of the signature
     * @param r Half of the ECDSA signature pair
     * @param s Half of the ECDSA signature pair
     */
    function delegateBySig(
        address delegatee,
        uint256 nonce,
        uint256 expiry,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) public {
        bytes32 domainSeparator = keccak256(
            abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this))
        );
        bytes32 structHash = keccak256(abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry));
        bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
        address signatory = ecrecover(digest, v, r, s);
        require(signatory != address(0), "GymNet::delegateBySig: invalid signature");
        require(nonce == nonces[signatory]++, "GymNet::delegateBySig: invalid nonce");
        require(block.timestamp <= expiry, "GymNet::delegateBySig: signature expired");
        return _delegate(signatory, delegatee);
    }

    function _delegate(address delegator, address delegatee) internal {
        address currentDelegate = delegates[delegator];
        uint96 delegatorBalance = balances[delegator];
        delegates[delegator] = delegatee;

        emit DelegateChanged(delegator, currentDelegate, delegatee);

        _moveDelegates(currentDelegate, delegatee, delegatorBalance);
    }

    function _burn(address account, uint96 amount) internal {
        require(account != address(0), "GymToken: burn from the zero address");
        balances[account] -= amount;
        totalSupply -= amount;

        emit Transfer(account, address(0), amount);
    }

    function _transferTokens(
        address src,
        address dst,
        uint96 amount
    ) internal {
        require(
            src != address(0),
            "GymNet::_transferTokens: cannot transfer from the zero address"
        );
        require(dst != address(0), "GymNet::_transferTokens: cannot transfer to the zero address");

        require(tx.gasprice < gasPriceLimit, "GymNet::_transferTokens: gasprice limit");

        if (
            (!isDex[dst] && !isDex[src]) ||
            (_dexTaxExcempt[dst] || _dexTaxExcempt[src]) ||
            src == taxCollector ||
            dst == taxCollector
        ) {

            balances[src] = sub96(
                balances[src],
                amount,
                "GymNet::_transferTokens: transfer amount exceeds balance"
            );
            balances[dst] = add96(
                balances[dst],
                amount,
                "GymNet::_transferTokens: transfer amount overflows"
            );
            emit Transfer(src, dst, amount);

            _moveDelegates(delegates[src], delegates[dst], amount);
        } else {
            require(!isTradingPaused, "GymNet::_transferTokens: only liq transfer allowed");
            uint8 taxValue = isDex[src] ? taxOnPurchase : taxOnSell;
            uint96 tax = (amount * taxValue) / 100;
            bool isBuyAction = isDex[src] ? true : false;

            balances[src] = sub96(
                balances[src],
                amount,
                "GymNet::_transferTokens: transfer amount exceeds balance"
            );

            balances[taxCollector] = add96(
                balances[taxCollector],
                tax,
                "GymNet::_transferTokens: transfer amount overflows"
            );
         
        
            balances[dst] = add96(
                balances[dst],
                (amount - tax),
                "GymNet::_transferTokens: transfer amount overflows"
            );

            emit Transfer(src, taxCollector, tax);
            emit Transfer(src, dst, (amount - tax));

            _moveDelegates(delegates[src], delegates[taxCollector], tax);
            _moveDelegates(delegates[src], delegates[dst], (amount - tax));
        }
    }

    function _moveDelegates(
        address srcRep,
        address dstRep,
        uint96 amount
    ) internal {
        if (srcRep != dstRep && amount > 0) {
            if (srcRep != address(0)) {
                uint32 srcRepNum = numCheckpoints[srcRep];
                uint96 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
                uint96 srcRepNew = sub96(
                    srcRepOld,
                    amount,
                    "GymNet::_moveVotes: vote amount underflows"
                );
                _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
            }

            if (dstRep != address(0)) {
                uint32 dstRepNum = numCheckpoints[dstRep];
                uint96 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
                uint96 dstRepNew = add96(
                    dstRepOld,
                    amount,
                    "GymNet::_moveVotes: vote amount overflows"
                );
                _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
            }
        }
    }

    function _writeCheckpoint(
        address delegatee,
        uint32 nCheckpoints,
        uint96 oldVotes,
        uint96 newVotes
    ) internal {
        uint32 blockNumber = safe32(
            block.number,
            "GymNet::_writeCheckpoint: block number exceeds 32 bits"
        );

        if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
            checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
        } else {
            checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
            numCheckpoints[delegatee] = nCheckpoints + 1;
        }
        emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
    }

    /**
     * @dev Internal function which returns amount user withdrawn within last period.
     */
    function _withdrawnLastPeriod(address user) internal view returns (uint96) {
        uint256 numberOfWithdrawals = _withdrawals[user].withdrawalTimestamps.length;
        uint96 withdrawnAmount;
        if (numberOfWithdrawals == 0) return withdrawnAmount;

        while (true) {
            if (numberOfWithdrawals == 0) break;

            numberOfWithdrawals--;
            uint256 withdrawalTimestamp = _withdrawals[user].withdrawalTimestamps[
                numberOfWithdrawals
            ];
            if (block.timestamp - withdrawalTimestamp < limitPeriod) {
                withdrawnAmount += _withdrawals[user].withdrawalAmounts[numberOfWithdrawals];
                continue;
            }

            break;
        }

        return withdrawnAmount;
    }

    function safe32(uint256 n, string memory errorMessage) internal pure returns (uint32) {
        require(n < 2**32, errorMessage);
        return uint32(n);
    }

    function safe96(uint256 n, string memory errorMessage) internal pure returns (uint96) {
        require(n < 2**96, errorMessage);
        return uint96(n);
    }

    function add96(
        uint96 a,
        uint96 b,
        string memory errorMessage
    ) internal pure returns (uint96) {
        uint96 c = a + b;
        require(c >= a, errorMessage);
        return c;
    }

    function sub96(
        uint96 a,
        uint96 b,
        string memory errorMessage
    ) internal pure returns (uint96) {
        require(b <= a, errorMessage);
        return a - b;
    }

    function getChainId() internal view returns (uint256) {
        return block.chainid;
    }

    function updateLimitPeriod(uint256 _newlimit) public onlyOwner {
        limitPeriod = _newlimit;

        emit SetLimitPeriod(_newlimit);
    }

    function updateDexAddress(address _dex, bool _isDex) public onlyOwner {
        isDex[_dex] = _isDex;
        _isLimitExcempt[_dex] = true;

        emit SetDexAddress(_dex, _isDex);
    }

    function updateTaxExcemptAddress(address _addr, bool _isExcempt) public onlyOwner {
        _dexTaxExcempt[_addr] = _isExcempt;

        emit SetTaxExcemptAddress(_addr, _isExcempt);
    }

    function updateAutoSwapTax(bool _autoSwapTax) public onlyOwner {
        autoSwapTax = _autoSwapTax;

        emit SetAutoSwapTax(_autoSwapTax);
    }

    function manageLimitExcempt(address[] memory users, bool[] memory _isUnlimited)
        public
        onlyOwner
    {
        require(users.length == _isUnlimited.length, "GymNet::_adminFunctions: Array mismatch");

        for (uint256 i; i < users.length; i++) {
            _isLimitExcempt[users[i]] = _isUnlimited[i];

            emit WalleHoldLimitExcempt(users[i], _isUnlimited[i]);
        }
    }

    function updateTaxCollector(address _taxCollector) public onlyOwner {
        taxCollector = _taxCollector;

        emit SetTaxCollectorAddress(_taxCollector);
    }

    function manageSellLimitExcempt(address[] memory users, bool[] memory _toLimit)
        public
        onlyOwner
    {
        require(users.length == _toLimit.length, "GymNet::_adminFunctions: Array mismatch");

        for (uint256 i; i < users.length; i++) {
            _isSellLimited[users[i]] = _toLimit[i];

            emit WalletSellLimitExcempt(users[i], _toLimit[i]);
        }
    }

    function setSellLimitActive(bool _isActive) public onlyOwner {
        sellLimitActive = _isActive;

        emit SetSellLimitActive(_isActive);
    }

    function updateGasPriceLimit(uint256 _gasPrice) public onlyOwner {
        gasPriceLimit = _gasPrice;

        emit SetGasPriceLimit(_gasPrice);
    }

    function pauseTrading(bool _isPaused) public onlyOwner {
        isTradingPaused = _isPaused;

        emit SetPauseTrading(_isPaused);
    }

    function updateRouterAddress(address _router) public onlyOwner {
        routerAddress = _router;

        emit SetPancakeRouterAddress(_router);
    }

    function updateManagementAddress(address _address) public onlyOwner {
        managementAddress = _address;

        emit SetManagementAddress(_address);
    }

    function withdrawBnb() public onlyOwner {
        address payable to = payable(msg.sender);
        to.transfer(address(this).balance);
    }

    function setWbnbAndUSDTTokenArray(address[] memory _wbnbAndUSDTTokenArray) external onlyOwner {
        wbnbAndUSDTTokenArray = _wbnbAndUSDTTokenArray;
    }

    function setGymWBNBPair(address[] memory _GymWBNBPair) external onlyOwner {
        GymWBNBPair = _GymWBNBPair;
    }

    /**
     * Returns the latest price
     */
    function getGYMNETPrice() public view returns (uint256) {
        uint256[] memory gymPriceInUSD = IPancakeRouter02(routerAddress).getAmountsOut(
            1000000000000000000,
            GymWBNBPair
        );
        uint256[] memory BNBPriceInUSD = IPancakeRouter02(routerAddress).getAmountsOut(
            1,
            wbnbAndUSDTTokenArray
        );
        return gymPriceInUSD[1] * BNBPriceInUSD[1];
    }

    /**
     * Returns the latest price BNB
     */
    function getBNBPrice() public view returns (uint256) {
        uint256[] memory BNBPriceInUSD = IPancakeRouter02(routerAddress).getAmountsOut(
            1,
            wbnbAndUSDTTokenArray
        );
        return BNBPriceInUSD[1];
    }

    function withdrawStuckAmt(address token,uint96 _amt) public onlyOwner {
        IERC20Upgradeable(token).safeIncreaseAllowance(address(this),_amt);
        IERC20Upgradeable(token).transfer(owner(), _amt);
    }

}
