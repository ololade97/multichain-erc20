// SPDX-License-Identifier: MIT
// File contracts/SafeMath.sol



pragma solidity ^0.8.4;

library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}


// File contracts/SafeMathUint.sol



pragma solidity ^0.8.4;

/**
 * @title SafeMathUint
 * @dev Math operations with safety checks that revert on error
 */
library SafeMathUint {
    function toInt256Safe(uint256 a) internal pure returns (int256) {
        int256 b = int256(a);
        require(b >= 0);
        return b;
    }
}


// File contracts/SafeMathInt.sol



/*
MIT License

Copyright (c) 2018 requestnetwork
Copyright (c) 2018 Fragments, Inc.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

pragma solidity ^0.8.4;

/**
 * @title SafeMathInt
 * @dev Math operations for int256 with overflow safety checks.
 */
library SafeMathInt {
    int256 private constant MIN_INT256 = int256(1) << 255;
    int256 private constant MAX_INT256 = ~(int256(1) << 255);

    /**
     * @dev Multiplies two int256 variables and fails on overflow.
     */
    function mul(int256 a, int256 b) internal pure returns (int256) {
        int256 c = a * b;

        // Detect overflow when multiplying MIN_INT256 with -1
        require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
        require((b == 0) || (c / b == a));
        return c;
    }

    /**
     * @dev Division of two int256 variables and fails on overflow.
     */
    function div(int256 a, int256 b) internal pure returns (int256) {
        // Prevent overflow when dividing MIN_INT256 by -1
        require(b != -1 || a != MIN_INT256);

        // Solidity already throws when dividing by 0.
        return a / b;
    }

    /**
     * @dev Subtracts two int256 variables and fails on overflow.
     */
    function sub(int256 a, int256 b) internal pure returns (int256) {
        int256 c = a - b;
        require((b >= 0 && c <= a) || (b < 0 && c > a));
        return c;
    }

    /**
     * @dev Adds two int256 variables and fails on overflow.
     */
    function add(int256 a, int256 b) internal pure returns (int256) {
        int256 c = a + b;
        require((b >= 0 && c >= a) || (b < 0 && c < a));
        return c;
    }

    /**
     * @dev Converts to absolute value, and fails on overflow.
     */
    function abs(int256 a) internal pure returns (int256) {
        require(a != MIN_INT256);
        return a < 0 ? -a : a;
    }


    function toUint256Safe(int256 a) internal pure returns (uint256) {
        require(a >= 0);
        return uint256(a);
    }
}


// File contracts/IterableMapping.sol


pragma solidity ^0.8.4;

// https://solidity-by-example.org/app/iterable-mapping/

library IterableMapping {
    // Iterable mapping from address to uint;
    struct Map {
        address[] keys;
        mapping(address => uint) values;
        mapping(address => uint) indexOf;
        mapping(address => bool) inserted;
    }

    function get(Map storage map, address key) public view returns (uint) {
        return map.values[key];
    }

    function getIndexOfKey(Map storage map, address key) public view returns (int) {
        if(!map.inserted[key]) {
            return -1;
        }
        return int(map.indexOf[key]);
    }

    function getKeyAtIndex(Map storage map, uint index) public view returns (address) {
        return map.keys[index];
    }

    function size(Map storage map) public view returns (uint) {
        return map.keys.length;
    }

    function set(Map storage map, address key, uint val) public {
        if (map.inserted[key]) {
            map.values[key] = val;
        } else {
            map.inserted[key] = true;
            map.values[key] = val;
            map.indexOf[key] = map.keys.length;
            map.keys.push(key);
        }
    }

    function remove(Map storage map, address key) public {
        if (!map.inserted[key]) {
            return;
        }

        delete map.inserted[key];
        delete map.values[key];

        uint index = map.indexOf[key];
        uint lastIndex = map.keys.length - 1;
        address lastKey = map.keys[lastIndex];

        map.indexOf[lastKey] = index;
        delete map.indexOf[key];

        map.keys[index] = lastKey;
        map.keys.pop();
    }
}


// File contracts/UlandRewardTracker.sol

//
//  ██    ██ ██       █████  ███    ██ ██████       ██  ██████
//  ██    ██ ██      ██   ██ ████   ██ ██   ██      ██ ██    ██
//  ██    ██ ██      ███████ ██ ██  ██ ██   ██      ██ ██    ██
//  ██    ██ ██      ██   ██ ██  ██ ██ ██   ██      ██ ██    ██
//   ██████  ███████ ██   ██ ██   ████ ██████   ██  ██  ██████
//

pragma solidity ^0.8.4;

// @title Rewards tracker / uland.io
// @author 57pixels@uland.io

// @dev RewardTracker inspired by Roger-Wu ERC1726 Dividend Paying Token
// https://github.com/Roger-Wu/erc1726-dividend-paying-token/tree/master/contracts
contract UlandRewardTracker {
	using SafeMath for uint256;
	using SafeMathUint for uint256;
	using SafeMathInt for int256;

	using IterableMapping for IterableMapping.Map;

	IterableMapping.Map private tokenHoldersMap;

	mapping(address => bool) public excludedFromDividends;
	mapping(address => uint256) public lastClaimTimes;
	mapping(address => uint256) public staticRewardBalances;
	mapping(address => uint256) public staticRewardPayouts;
	mapping(address => uint256) private _rewardsBalances;
	mapping(address => int256) internal magnifiedDividendCorrections;
	mapping(address => uint256) internal withdrawnDividends;

	uint256 public claimWait;
	uint256 public constant MIN_TOKEN_BALANCE_FOR_DIVIDENDS = 1;
	uint256 private _totalRewardsSupply;
	uint256 internal constant magnitude = 2**128;
	uint256 internal _magnifiedDividendPerShare;
	uint256 private _totalRewardsDistributed;

	constructor() {
		claimWait = 0; // No waiting
	}

	/*
	 * Public
	 */

	function getNumberOfRewardHolders() public view returns (uint256) {
		return tokenHoldersMap.keys.length;
	}

	function getClaimWait() public view returns (uint256) {
		return claimWait;
	}

	//getAccount
	function getAccountRewardsInfo(address _account)
		public
		view
		returns (
			address account,
			int256 index,
			uint256 withdrawableDividends,
			uint256 totalDividends,
			uint256 lastClaimTime,
			uint256 nextClaimTime,
			uint256 totalWidthdrawn
		)
	{
		account = _account;

		index = tokenHoldersMap.getIndexOfKey(account);

		withdrawableDividends = withdrawableDividendOf(account).add(
			staticRewardBalances[account]
		);

		/// @dev Amount of dividend in wei that an address has earned in total.
		totalDividends = accumulativeDividendOf(account)
			.add(staticRewardPayouts[account])
			.add(staticRewardBalances[account]);

		lastClaimTime = lastClaimTimes[account];
		nextClaimTime = lastClaimTime > 0 ? lastClaimTime.add(claimWait) : 0;
		totalWidthdrawn = withdrawnDividendOf(_account).add(
			staticRewardBalances[account]
		);
	}

	function getAccountRewardsInfoAtIndex(uint256 index)
		public
		view
		returns (
			address,
			int256,
			uint256,
			uint256,
			uint256,
			uint256,
			uint256
		)
	{
		if (index >= tokenHoldersMap.size()) {
			return (
				0x0000000000000000000000000000000000000000,
				-1,
				0,
				0,
				0,
				0,
				0
			);
		}

		address account = tokenHoldersMap.getKeyAtIndex(index);
		return getAccountRewardsInfo(account);
	}

	function totalRewardsSupply() public view virtual returns (uint256) {
		return _totalRewardsSupply;
	}

	function totalRewardDistributed() public view virtual returns (uint256) {
		return _totalRewardsDistributed;
	}

	function rewardsBalanceOf(address account)
		public
		view
		virtual
		returns (uint256)
	{
		return _rewardsBalances[account];
	}

	/// @notice View the amount of dividend in wei that an address can withdraw.
	/// @param _owner The address of a token holder.
	/// @return The amount of dividend in wei that `_owner` can withdraw.
	function dividendOf(address _owner) public view returns (uint256) {
		return withdrawableDividendOf(_owner);
	}

	/// @notice View the amount of dividend in wei that an address can withdraw.
	/// @param _owner The address of a token holder.
	/// @return The amount of dividend in wei that `_owner` can withdraw.
	function withdrawableDividendOf(address _owner)
		public
		view
		returns (uint256)
	{
		return accumulativeDividendOf(_owner).sub(withdrawnDividends[_owner]);
	}

	/// @notice View the amount of dividend in wei that an address has withdrawn.
	/// @param _owner The address of a token holder.
	/// @return The amount of dividend in wei that `_owner` has withdrawn.
	function withdrawnDividendOf(address _owner) public view returns (uint256) {
		return withdrawnDividends[_owner];
	}

	/// @notice View the amount of dividend in wei that an address has earned in total.
	/// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
	/// = (_magnifiedDividendPerShare * balanceOf(_owner) + magnifiedDividendCorrections[_owner]) / magnitude
	/// @param _owner The address of a token holder.
	/// @return The amount of dividend in wei that `_owner` has earned in total.
	function accumulativeDividendOf(address _owner)
		public
		view
		returns (uint256)
	{
		return
			_magnifiedDividendPerShare
				.mul(rewardsBalanceOf(_owner))
				.toInt256Safe()
				.add(magnifiedDividendCorrections[_owner])
				.toUint256Safe() / magnitude;
	}

	/*
	 * Internal
	 */

	function excludeFromDividends(address account) internal {
		require(!excludedFromDividends[account]);
		excludedFromDividends[account] = true;

		_setBalance(account, 0);
		tokenHoldersMap.remove(account);
		staticRewardBalances[account] = 0;

		emit ExcludedFromDividends(account);
	}

	function _updateClaimWait(uint256 newClaimWait) internal {
		require(
			newClaimWait >= 0 && newClaimWait <= 86400,
			"claimWait must be updated to between 0 and 24 hours"
		);
		require(
			newClaimWait != claimWait,
			"Cannot update claimWait to same value"
		);
		emit ClaimWaitUpdated(newClaimWait, claimWait);
		claimWait = newClaimWait;
	}

	function _addStaticReward(address recipient, uint256 amount) internal {
		staticRewardBalances[recipient] = staticRewardBalances[recipient].add(
			amount
		);
		_totalRewardsDistributed = _totalRewardsDistributed.add(amount);
	}

	function canClaim(uint256 lastClaimTime) private view returns (bool) {
		if (lastClaimTime > block.timestamp) {
			return false;
		}
		return (block.timestamp - lastClaimTime) >= claimWait;
	}

	function processAccount(address payable account)
		internal
		returns (uint256)
	{
		require(canClaim(lastClaimTimes[account]), "CLAIMWAIT");

		uint256 amount = _withdrawDividendOfUser(account);
		uint256 staticReward = staticRewardBalances[account];

		if (staticReward > 0) {
			staticRewardBalances[account] = 0;
			staticRewardPayouts[account] = staticRewardPayouts[account].add(
				staticReward
			);
			amount = amount.add(staticReward);
		}

		if (amount > 0) {
			lastClaimTimes[account] = block.timestamp;
		}

		return amount;
	}

	/// @notice Distributes target to token holders as dividends.
	function distributeRewards(uint256 amount) internal {
		if (totalRewardsSupply() > 0) {
			if (amount > 0) {
				_magnifiedDividendPerShare = _magnifiedDividendPerShare.add(
					(amount).mul(magnitude) / _totalRewardsSupply
				);
				emit DividendsDistributed(msg.sender, amount);

				_totalRewardsDistributed = _totalRewardsDistributed.add(amount);
			}
		}
	}

	/// @notice Withdraws the ether distributed to the sender.
	/// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
	function _withdrawDividendOfUser(address payable user)
		internal
		returns (uint256)
	{
		uint256 _withdrawableDividend = withdrawableDividendOf(user);
		if (_withdrawableDividend > 0) {
			withdrawnDividends[user] = withdrawnDividends[user].add(
				_withdrawableDividend
			);
			emit DividendWithdrawn(user, _withdrawableDividend);
			return _withdrawableDividend;
		}
		return 0;
	}

	/// @dev Internal function that mints tokens to an account.
	/// Update magnifiedDividendCorrections to keep dividends unchanged.
	/// @param account The account that will receive the created tokens.
	/// @param amount The amount that will be created.
	function _mintRewards(address account, uint256 amount) internal {
		require(account != address(0), "ERC20: mint to the zero address");

		_totalRewardsSupply = _totalRewardsSupply.add(amount);
		_rewardsBalances[account] = _rewardsBalances[account].add(amount);

		magnifiedDividendCorrections[account] = magnifiedDividendCorrections[
			account
		].sub((_magnifiedDividendPerShare.mul(amount)).toInt256Safe());
	}

	/// @dev Internal function that burns an amount of the token of a given account.
	/// Update magnifiedDividendCorrections to keep dividends unchanged.
	/// @param account The account whose tokens will be burnt.
	/// @param amount The amount that will be burnt.
	function _burnRewards(address account, uint256 amount) internal {
		require(account != address(0), "ERC20: burn from the zero address");

		_rewardsBalances[account] = _rewardsBalances[account].sub(
			amount,
			"ERC20: burn amount exceeds balance"
		);
		_totalRewardsSupply = _totalRewardsSupply.sub(amount);

		magnifiedDividendCorrections[account] = magnifiedDividendCorrections[
			account
		].add((_magnifiedDividendPerShare.mul(amount)).toInt256Safe());
	}

	function _setBalance(address account, uint256 newBalance) private {
		uint256 currentBalance = rewardsBalanceOf(account);

		if (newBalance > currentBalance) {
			uint256 mintAmount = newBalance.sub(currentBalance);
			_mintRewards(account, mintAmount);
		} else if (newBalance < currentBalance) {
			uint256 burnAmount = currentBalance.sub(newBalance);
			_burnRewards(account, burnAmount);
		}
	}

	/// @dev Uses balance as rewards dividends factor
	function _setRewardsFactor(address payable account, uint256 newBalance)
		internal
	{
		if (excludedFromDividends[account]) {
			return;
		}
		if (newBalance >= MIN_TOKEN_BALANCE_FOR_DIVIDENDS) {
			_setBalance(account, newBalance);
			tokenHoldersMap.set(account, newBalance);
		} else {
			_setBalance(account, 0);
			tokenHoldersMap.remove(account);
		}
	}

	/*
	 * Events
	 */

	event ExcludedFromDividends(address indexed account);
	event ClaimWaitUpdated(uint256 indexed newValue, uint256 indexed oldValue);

	/// @dev This event MUST emit when ether is distributed to token holders.
	/// @param from The address which sends ether to this contract.
	/// @param weiAmount The amount of distributed ether in wei.
	event DividendsDistributed(address indexed from, uint256 weiAmount);

	/// @dev This event MUST emit when an address withdraws their dividend.
	/// @param to The address which withdraws ether from this contract.
	/// @param weiAmount The amount of withdrawn ether in wei.
	event DividendWithdrawn(address indexed to, uint256 weiAmount);
}


// File contracts/IERC20.sol



pragma solidity ^0.8.4;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}


// File contracts/IERC20Metadata.sol



pragma solidity ^0.8.4;
/**
 * @dev Interface for the optional metadata functions from the ERC20 standard.
 *
 * _Available since v4.1._
 */
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


// File contracts/Context.sol



pragma solidity ^0.8.4;

/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}


// File contracts/ERC20.sol



pragma solidity ^0.8.4;
/**
 * @dev Implementation of the {IERC20} interface.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using {_mint}.
 * For a generic mechanism see {ERC20PresetMinterPauser}.
 *
 * TIP: For a detailed writeup see our guide
 * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
 * to implement supply mechanisms].
 *
 * We have followed general OpenZeppelin guidelines: functions revert instead
 * of returning `false` on failure. This behavior is nonetheless conventional
 * and does not conflict with the expectations of ERC20 applications.
 *
 * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
 * This allows applications to reconstruct the allowance for all accounts just
 * by listening to said events. Other implementations of the EIP may not emit
 * these events, as it isn't required by the specification.
 *
 * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
 * functions have been added to mitigate the well-known issues around setting
 * allowances. See {IERC20-approve}.
 */
contract ERC20 is Context, IERC20, IERC20Metadata {
    using SafeMath for uint256;

    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;

    /**
     * @dev Sets the values for {name} and {symbol}.
     *
     * The default value of {decimals} is 18. To select a different value for
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
    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    /**
     * @dev See {IERC20-allowance}.
     */
    function allowance(address owner, address spender) public view virtual override returns (uint256) {
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
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
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
    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
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
    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
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

        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     */
    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
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

        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
        _totalSupply = _totalSupply.sub(amount);
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
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * will be to transferred to `to`.
     * - when `from` is zero, `amount` tokens will be minted for `to`.
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


// File contracts/Ownable.sol

pragma solidity ^0.8.4;


contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}


// File contracts/IUniswapV2Pair.sol



pragma solidity ^0.8.4;

interface IUniswapV2Pair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint);

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;

    event Mint(address indexed sender, uint amount0, uint amount1);
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint);
    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function price0CumulativeLast() external view returns (uint);
    function price1CumulativeLast() external view returns (uint);
    function kLast() external view returns (uint);

    function mint(address to) external returns (uint liquidity);
    function burn(address to) external returns (uint amount0, uint amount1);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function skim(address to) external;
    function sync() external;

    function initialize(address, address) external;
}


// File contracts/IUniswapV2Factory.sol



pragma solidity ^0.8.4;

interface IUniswapV2Factory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    function feeTo() external view returns (address);
    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);

    function createPair(address tokenA, address tokenB) external returns (address pair);

    function setFeeTo(address) external;
    function setFeeToSetter(address) external;
}


// File contracts/IUniswapV2Router.sol



pragma solidity ^0.8.4;

interface IUniswapV2Router01 {
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
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
    external
    payable
    returns (uint[] memory amounts);
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
    external
    returns (uint[] memory amounts);
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
    external
    returns (uint[] memory amounts);
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
    external
    payable
    returns (uint[] memory amounts);

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}



// pragma solidity >=0.6.2;

interface IUniswapV2Router02 is IUniswapV2Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountETH);
    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}


// File contracts/UlandToken.sol

//
//  ██    ██ ██       █████  ███    ██ ██████       ██  ██████
//  ██    ██ ██      ██   ██ ████   ██ ██   ██      ██ ██    ██
//  ██    ██ ██      ███████ ██ ██  ██ ██   ██      ██ ██    ██
//  ██    ██ ██      ██   ██ ██  ██ ██ ██   ██      ██ ██    ██
//   ██████  ███████ ██   ██ ██   ████ ██████   ██  ██  ██████
//

pragma solidity ^0.8.4;

// @title Token contract / uland.io
// @author 57pixels@uland.io
// @whitepaper https://uland.io/Whitepaper.pdf
contract Uland is UlandRewardTracker, ERC20, Ownable {
	using SafeMath for uint256;

	IUniswapV2Router02 public uniswapV2Router;
	address public uniswapV2Pair;

	mapping(address => bool) private _isExcludedFromFees; // exclude from fees
	mapping(address => bool) public canTransferBeforeTradingIsEnabled; // addresses that can make transfers before presale is over
	mapping(address => bool) public automatedMarketMakerPairs; // automatic market maker pairs
	mapping(address => bool) public nftContracts; // list of nft contracts that is allowed to interact
	mapping(address => uint256) public treasureClaims;

	address public deadWallet = 0x000000000000000000000000000000000000dEaD;
	address public liquiditySwapWallet = 0x24554C414E440000000000000000000000000001; // $ULAND Internal Locked Liquidity swap
	address public rewardsWallet = 0x24554c414E440000000000000000000000000002; // $ULAND Internal Rewards Wallet
	address public airdropWallet = 0x24554c414e440000000000000000000000000008; // $ULAND Internal Airdrop Wallet
	address public teamWallet = 0x788479Bcee9a88B1290Fa51403F9c15C465317B0;
	address public marketingWallet = 0x3B3E40522ba700a0c2E9030431E5e7fD9af28775;

	uint256 public constant TOTAL_SUPPLY = 1000000000 * (10**18); // 1 BN

	uint256 public LIQUIDATE_TOKENS_TRIGGER = 5 * (10**18); // Trigger to liquidiate ETH/BNB tokens
	uint256 public LIQUIDATE_ETH_TRIGGER = 5 * (10**18); // Trigger to liquidiate $ULAND tokens
	uint16 public REWARDS_TAX = 25; // 2.5%
	uint16 public LIQUIDITY_TAX = 50; // 5%

	uint256 public treasureAllowanceCounter = 0;
	uint256 public treasureAmount = 0;

	bool public tradingEnabled;
	bool private inSwapAndLiquify;

	modifier onlyNFT() {
		require(nftContracts[msg.sender]);
		_;
	}

	modifier lockTheSwap() {
		inSwapAndLiquify = true;
		_;
		inSwapAndLiquify = false;
	}

	constructor(address router) ERC20("ULAND TOKEN", "ULAND") {
		IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(router);

		// Create a uniswap pair for this new token
		address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
			.createPair(address(this), _uniswapV2Router.WETH());

		uniswapV2Router = _uniswapV2Router;
		uniswapV2Pair = _uniswapV2Pair;

		setAutomatedMarketMakerPair(_uniswapV2Pair, true);

		// exclude from receiving dividends
		excludeFromDividends(address(this));
		excludeFromDividends(owner());
		excludeFromDividends(rewardsWallet);
		excludeFromDividends(marketingWallet);
		excludeFromDividends(airdropWallet);
		excludeFromDividends(address(_uniswapV2Router));
		excludeFromDividends(deadWallet);

		// exclude from paying fees or having max transaction amount
		excludeFromFees(address(this));
		excludeFromFees(owner());
		excludeFromFees(address(_uniswapV2Router));
		excludeFromFees(rewardsWallet);
		excludeFromFees(teamWallet);
		excludeFromFees(marketingWallet);
		excludeFromFees(airdropWallet);

		canTransferBeforeTradingIsEnabled[owner()] = true; // enable owner wallet to send tokens before presales are over.

		_mint(owner(), TOTAL_SUPPLY); // Total supply: 1BN

		_transfer(owner(), teamWallet, TOTAL_SUPPLY.div(100).mul(5)); // 5%
		_transfer(owner(), airdropWallet, TOTAL_SUPPLY.div(100).mul(5)); // 5%
		_transfer(owner(), liquiditySwapWallet, TOTAL_SUPPLY.div(10000).mul(3750)); // 50% of public sale locked and released through NFT sales
		_transfer(owner(), marketingWallet, TOTAL_SUPPLY.div(100).mul(5)); // 5%
		_transfer(owner(), deadWallet, TOTAL_SUPPLY.div(100).mul(10)); // 10%
	}

	/*
	 * @notice Receive ETH/BNB from NFT
	 * @notice Will automatically be converted into liquidity
	 */
	receive() external payable {}

	/*
	 * @notice Transfer
	 * @notice Fees
	 * @notice  - `Rewards` 2.5% (Distribution Tax paid back to all NFT holders),
	 * @notice  - `Liquidity` 5.0% (To liquidity for $ULAND)
	 */
	function _transfer(
		address from,
		address to,
		uint256 amount
	) internal override {
		require(from != address(0), "ERC20: transfer from the zero address");
		require(to != address(0), "ERC20: transfer to the zero address");

		bool tradingIsEnabled = tradingEnabled;

		// only whitelisted addresses can make transfers before the public presale is over.
		if (!tradingIsEnabled) {
			require(
				canTransferBeforeTradingIsEnabled[from] ||
					canTransferBeforeTradingIsEnabled[tx.origin],
				"Trading disabled"
			);
		}

		if (amount == 0) {
			super._transfer(from, to, 0);
			return;
		}

		// SET BALANCE
		uint256 balance = amount;

		bool takeFee = tradingIsEnabled && !inSwapAndLiquify;

		// if any account belongs to _isExcludedFromFee account then remove the fee
		if (
			_isExcludedFromFees[from] ||
			_isExcludedFromFees[to] ||
			_isExcludedFromFees[tx.origin]
		) {
			takeFee = false;
		}

		if (takeFee) {
			balance = takeFees(from, balance);
		}

		uint256 ethBalance = address(this).balance;
		uint256 liquidityBalance = balanceOf(address(this));

		if (
			takeFee == true &&
			!automatedMarketMakerPairs[from] &&
			!inSwapAndLiquify &&
			from != uniswapV2Pair
		) {
			if (ethBalance > LIQUIDATE_ETH_TRIGGER) {
				swapAndLiquifyEth(ethBalance);
			} else if (liquidityBalance >= LIQUIDATE_TOKENS_TRIGGER) {
				swapAndLiquify(liquidityBalance);
			}
		}

		// @dev Transfer remaining balance
		super._transfer(from, to, balance);
	}

	/*
	 * @notice Claim rewards
	 */
	function claim() external {
		uint256 payout = processAccount(payable(msg.sender));
		if (payout > 0) {
			super._transfer(rewardsWallet, msg.sender, payout);
		}
		emit Claim(msg.sender, payout);
	}

	function isExcludedFromFees(address account) public view returns (bool) {
		return _isExcludedFromFees[account];
	}

	/*
	 * @notice $ULAND World Map Treasure hunt
	 */
	function treasureClaim() external {
		require(treasureAllowanceCounter > 0, "TREASURECHEST_EXHAUSTED");
		require(treasureClaims[msg.sender] < block.timestamp, "7DAY_COOLDOWN");
		require(balanceOf(airdropWallet) > treasureAmount);

		treasureClaims[msg.sender] = block.timestamp.add(1 weeks);
		treasureAllowanceCounter = treasureAllowanceCounter.sub(1);
		super._transfer(airdropWallet, rewardsWallet, treasureAmount); // Deduct from airdropWallet to rewardWallet
		_addStaticReward(msg.sender, treasureAmount);
		emit TreasureFound(msg.sender, treasureAmount);
	}

	/*
	 * Internal
	 */

	 
	function swapTokensForEth(uint256 tokenAmount) private {
		// generate the uniswap pair path of token -> weth
		address[] memory path = new address[](2);

		path[0] = address(this); //
		path[1] = uniswapV2Router.WETH();

		_approve(address(this), address(uniswapV2Router), tokenAmount);

		// make the swap
		uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
			tokenAmount,
			0, // accept any amount of ETH/BNB
			path,
			address(this), // this contract will receive the ETH/BNB that were swapped from the token
			block.timestamp.add(300)
		);
	}

	/// @dev Provide liquidity using ETH/BNB. Use reserved funds in liquiditySwapWallet to provide liquidity
	function swapAndLiquifyEth(uint256 ethBalance) private lockTheSwap {
		/// @dev reserve0: token, reserve1: eth
		(uint256 reserve0, uint256 reserve1, ) = IUniswapV2Pair(uniswapV2Pair)
			.getReserves();

		if (reserve0 > 0 && reserve1 > 0) {
			uint256 quote = uniswapV2Router.quote(
				ethBalance,
				reserve1,
				reserve0
			);
			if (
				quote < totalSupply().div(100) &&
				balanceOf(liquiditySwapWallet) >= quote
			) {
				super._transfer(liquiditySwapWallet, address(this), quote);
				addLiquidity(quote, ethBalance);
			}
		}
	}

	function swapExactETHForTokens(address to, uint256 amount)
		internal
		returns (uint256)
	{
		// Swap
		address[] memory path = new address[](2);
		path[0] = uniswapV2Router.WETH();
		path[1] = address(this);

		uint256[] memory amounts = uniswapV2Router.swapExactETHForTokens{
			value: amount
		}(0, path, to, block.timestamp + 15);
		return amounts[1];
	}

	function swapAndLiquify(uint256 tokens) private lockTheSwap {
		// split the contract balance into halves
		uint256 half = tokens.div(2);
		uint256 otherHalf = tokens.sub(half);

		// capture the contract's current ETH/BNB balance.
		// this is so that we can capture exactly the amount of ETH that the
		// swap creates, and not make the liquidity event include any ETH that
		// has been manually sent to the contract

		uint256 initialBalance = address(this).balance;

		// swap tokens for ETH
		swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered

		// how much ETH/BNB did we just swap into
		uint256 newBalance = address(this).balance.sub(initialBalance);

		// add liquidity to uniswap
		addLiquidity(otherHalf, newBalance);

		emit SwapAndLiquify(half, newBalance, otherHalf);
	}

	function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
		_approve(address(this), address(uniswapV2Router), tokenAmount);

		// add the liquidity
		(uint256 amountToken, uint256 amountETH, uint256 liquidity) = uniswapV2Router
			.addLiquidityETH{ value: ethAmount }(
			address(this),
			tokenAmount,
			0, // slippage is unavoidable
			0, // slippage is unavoidable
			owner(),
			block.timestamp.add(300)
		);

		emit LiquidityAdded(amountToken, amountETH, liquidity);
	}

	/// @dev Calculate fees
	function takeFees(address from, uint256 balance)
		internal
		returns (uint256)
	{
		uint256 REWARDS_TAXAMOUNT = _getFeeAmount(balance, REWARDS_TAX); // 2.5%
		uint256 LIQUIDITY_TAXAMOUNT = _getFeeAmount(balance, LIQUIDITY_TAX); // 5.0%

		// @dev Distribute rewards to NFT holders
		if (REWARDS_TAXAMOUNT > 0) {
			balance = balance.sub(REWARDS_TAXAMOUNT);
			super._transfer(from, rewardsWallet, REWARDS_TAXAMOUNT);
			distributeRewards(REWARDS_TAXAMOUNT);
		}

		// Liquidity
		if (LIQUIDITY_TAXAMOUNT > 0) {
			balance = balance.sub(LIQUIDITY_TAXAMOUNT);
			super._transfer(from, address(this), LIQUIDITY_TAXAMOUNT);
		}

		return balance;
	}

	function _getFeeAmount(uint256 amount, uint16 fee)
		internal
		pure
		returns (uint256 feeAmount)
	{
		feeAmount = (amount.mul(fee)).div(1000);
	}

	/// @dev Random number generator to pick a winner for airdrops
	function _randomModulo(uint256 players, uint256 seed)
		internal
		view
		returns (uint256)
	{
		return
			uint256(
				keccak256(
					abi.encodePacked(
						block.timestamp,
						block.difficulty,
						seed,
						players
					)
				)
			) % players;
	}

	/*
	 * onlyNft
	 */

	function addStaticReward(address recipient, uint256 amount) public onlyNFT {
		require(amount > 0, "ASRAMOUNT");
		require(recipient != address(0), "ASRADR");

		_addStaticReward(recipient, amount);
	}

	function addAirdropReward(address recipient, uint256 amount)
		public
		onlyNFT
	{
		require(amount > 0, "ASRAMOUNT");
		require(recipient != address(0), "ASRADR");
		require(balanceOf(airdropWallet) >= amount, "ASRBAL");

		super._transfer(airdropWallet, rewardsWallet, amount); // Deduct from airdropWallet to rewardWallet
		_addStaticReward(recipient, amount);
	}

	/// @dev Rewards payout are distributed based on NFT population
	function setRewardsFactor(address holder, uint256 balance) public onlyNFT {
		_setRewardsFactor(payable(holder), balance);
	}

	/*
	 * onlyOwner
	 */

	/// @dev Activates public sale
	function activate() public onlyOwner {
		require(!tradingEnabled, "ULAND: Trading is already enabled");
		tradingEnabled = true;
	}

	/*
	 * @notice Airdrop reward giveaways from airdropWallet
	 */
	function bulkAirdrop(address[] memory recipient, uint256 amount)
		public
		onlyOwner
	{
		require(recipient.length > 0, "BA0");
		require(amount > 0, "BA1");

		for (uint256 i = 0; i < recipient.length; i++) {
			require(balanceOf(airdropWallet) >= amount, "BA2");
			super._transfer(airdropWallet, rewardsWallet, amount); // Deduct from airdropWalet to rewardWallet
			_addStaticReward(recipient[i], amount);
		}
		emit BulkAirdrop(recipient, amount);
	}

	/*
	 * @notice Grand Airdrop will select a random winner who holds an NFT asset
	 */
	function grandAirdrop(uint256 amount, uint256 seedValue)
		public
		onlyOwner
		returns (address)
	{
		require(amount > 0, "GA0");
		require(balanceOf(airdropWallet) >= amount, "GA1");
		require(getNumberOfRewardHolders() > 0, "GA2");

		// @dev Using to address for random seed
		uint256 winnerIndex = _randomModulo(
			getNumberOfRewardHolders(),
			seedValue
		);
		//console.log('winnerIndex = %s',winnerIndex);
		address winnerAddress;
		(winnerAddress, , , , , , ) = getAccountRewardsInfoAtIndex(winnerIndex);

		if (winnerAddress != address(0)) {
			super._transfer(
				airdropWallet,
				rewardsWallet, /*winnerAddress,*/
				amount
			);
			_addStaticReward(winnerAddress, amount);
			emit GrandAirdropPayout(winnerAddress, amount);
		}
		return winnerAddress;
	}

	function updateUniswapV2Router(address newAddress) public onlyOwner {
		require(
			newAddress != address(uniswapV2Router),
			"The router already has that address"
		);
		emit UpdatedUniswapV2Router(newAddress, address(uniswapV2Router));
		uniswapV2Router = IUniswapV2Router02(newAddress);
		address _uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory())
			.getPair(address(this), uniswapV2Router.WETH());
		uniswapV2Pair = _uniswapV2Pair;
	}

	function setNFTContractAllow(address contractAddress, bool access)
		public
		onlyOwner
	{
		nftContracts[contractAddress] = access;
		_isExcludedFromFees[contractAddress] = access;
		canTransferBeforeTradingIsEnabled[contractAddress] = access;
		emit NftContractAllowChange(contractAddress, access);
	}

	function excludeFromFees(address account) public onlyOwner {
		if (!_isExcludedFromFees[account]) {
			_isExcludedFromFees[account] = true;
		}
	}

	function setAutomatedMarketMakerPair(address pair, bool value)
		public
		onlyOwner
	{
		automatedMarketMakerPairs[pair] = value;
		emit SetAutomatedMarketMakerPair(pair, value);
	}

	function allowTransferBeforeTradingIsEnabled(address account, bool value)
		public
		onlyOwner
	{
		canTransferBeforeTradingIsEnabled[account] = value;
	}

	/// @dev Allows transactions from NFT before trading enabled
	function allowNftTrade(address account, bool value) public onlyNFT {
		canTransferBeforeTradingIsEnabled[account] = value;
	}

	function updateLiquidationThreshold(uint256 newValue) external onlyOwner {
		require(
			newValue <= 200000 * (10**18),
			"LIQUIDATE_TOKENS_TRIGGER must be less than 200,000"
		);
		emit LiquidationThresholdUpdated(newValue, LIQUIDATE_TOKENS_TRIGGER);
		LIQUIDATE_TOKENS_TRIGGER = newValue;
	}

	function updateClaimWait(uint256 claimWait) external onlyOwner {
		_updateClaimWait(claimWait);
	}

	/*
	 * @dev Burn liquiditySwap wallet once all NFT assets has been minted
	 */
	function burn(address wallet, uint256 amount) external onlyOwner {
		require(amount > 0, "AMOUNT");
		require(
			wallet == liquiditySwapWallet ||
				wallet == airdropWallet ||
				wallet == teamWallet ||
				wallet == marketingWallet
		);
        _transfer(wallet, deadWallet, amount);
		emit Burn(wallet, amount);
	}

	function updateTreasureAllowance(uint256 _allowanceCounter, uint256 _amount) external
		onlyOwner
	{
		treasureAllowanceCounter = _allowanceCounter;
		treasureAmount = _amount;
	}

	function setMarketingWallet(address _marketingWallet) public onlyOwner {
		marketingWallet = _marketingWallet;
	}

	function setTeamWallet(address _teamWallet) public onlyOwner {
		teamWallet = _teamWallet;
	}

	/// @dev Withdraw funds that gets stuck in contract by accident
	function emergencyWithdraw() external onlyOwner {
		payable(owner()).transfer(address(this).balance);
	}

	/*
	 * Events
	 */

	event Claim(address indexed claimaddress, uint256 amount);

	event Burn(address indexed wallet, uint256 amountToken);

	event UpdatedUniswapV2Router(
		address indexed newAddress,
		address indexed oldAddress
	);

	event GrandAirdropPayout(
		address indexed winnerWallet,
		uint256 indexed amount
	);

	event BulkAirdrop(address[] indexed recipient, uint256 amount);

	event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);

	event LiquidationThresholdUpdated(
		uint256 indexed newValue,
		uint256 indexed oldValue
	);

	event SwapAndLiquify(
		uint256 tokensSwapped,
		uint256 ethReceived,
		uint256 tokensIntoLiqudity
	);
	event LiquidityAdded(
		uint256 amountToken,
		uint256 amountETH,
		uint256 liquidity
	);

	event NftContractAllowChange(address indexed contractAddress, bool access);

	event TreasureFound(address indexed wallet, uint256 amountToken);
}