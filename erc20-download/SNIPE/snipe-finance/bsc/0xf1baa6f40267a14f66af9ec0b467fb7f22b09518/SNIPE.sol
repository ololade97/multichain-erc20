// SPDX-License-Identifier: MIT
/**____  _   _ ___ ____  _____                                                                                             
* / ___|| \ | |_ _|  _ \| ____|_                                                                                           
* \___ \|  \| || || |_) |  _| (_)                                                                                          
*  ___) | |\  || ||  __/| |___ _                                                                                           
* |____/|_| \_|___|_|  _|_____(_)__   _    ____ ____ _____     _______   ____  _______        ___    ____  ____  ____    _ 
* | ____|  / \  |  _ \| \ | | |  _ \ / \  / ___/ ___|_ _\ \   / / ____| |  _ \| ____\ \      / / \  |  _ \|  _ \/ ___|  | |
* |  _|   / _ \ | |_) |  \| | | |_) / _ \ \___ \___ \| | \ \ / /|  _|   | |_) |  _|  \ \ /\ / / _ \ | |_) | | | \___ \  | |
* | |___ / ___ \|  _ <| |\  | |  __/ ___ \ ___) |__) | |  \ V / | |___  |  _ <| |___  \ V  V / ___ \|  _ <| |_| |___) | |_|
* |_____/_/   \_\_| \_\_| \_| |_| /_/   \_\____/____/___|  \_/  |_____| |_| \_\_____|  \_/\_/_/   \_\_| \_\____/|____/  (_)
*/    

//Powered by snipefinance.com                                                                                                                    

/**
 *DEVELOPED by snipefinance.com 
 *Development services at: snipefinance.com 
 *Telegram contact: t.me/SnipeFinanceCom
*/

pragma solidity ^0.7.6;

abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

interface IUniswapV2Router01 {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    )
        external
        returns (
            uint256 amountA,
            uint256 amountB,
            uint256 liquidity
        );

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

    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityETH(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountToken, uint256 amountETH);

    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityETHWithPermit(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountToken, uint256 amountETH);

    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapTokensForExactTokens(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactETHForTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function swapTokensForExactETH(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactTokensForETH(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapETHForExactTokens(
        uint256 amountOut,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function quote(
        uint256 amountA,
        uint256 reserveA,
        uint256 reserveB
    ) external pure returns (uint256 amountB);

    function getAmountOut(
        uint256 amountIn,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountOut);

    function getAmountIn(
        uint256 amountOut,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountIn);

    function getAmountsOut(uint256 amountIn, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);

    function getAmountsIn(uint256 amountOut, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);
}

// File: contracts/IUniswapV2Router02.sol

interface IUniswapV2Router02 is IUniswapV2Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountETH);

    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable;

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;
}

interface IUniswapV2Factory {
    event PairCreated(
        address indexed token0,
        address indexed token1,
        address pair,
        uint256
    );

    function feeTo() external view returns (address);

    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB)
        external
        view
        returns (address pair);

    function allPairs(uint256) external view returns (address pair);

    function allPairsLength() external view returns (uint256);

    function createPair(address tokenA, address tokenB)
        external
        returns (address pair);

    function setFeeTo(address) external;

    function setFeeToSetter(address) external;
}

// File: contracts/IUniswapV2Pair.sol

interface IUniswapV2Pair {
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
    event Transfer(address indexed from, address indexed to, uint256 value);

    function name() external pure returns (string memory);

    function symbol() external pure returns (string memory);

    function decimals() external pure returns (uint8);

    function totalSupply() external view returns (uint256);

    function balanceOf(address owner) external view returns (uint256);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 value) external returns (bool);

    function transfer(address to, uint256 value) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);

    function PERMIT_TYPEHASH() external pure returns (bytes32);

    function nonces(address owner) external view returns (uint256);

    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    event Mint(address indexed sender, uint256 amount0, uint256 amount1);
    event Burn(
        address indexed sender,
        uint256 amount0,
        uint256 amount1,
        address indexed to
    );
    event Swap(
        address indexed sender,
        uint256 amount0In,
        uint256 amount1In,
        uint256 amount0Out,
        uint256 amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint256);

    function factory() external view returns (address);

    function token0() external view returns (address);

    function token1() external view returns (address);

    function getReserves()
        external
        view
        returns (
            uint112 reserve0,
            uint112 reserve1,
            uint32 blockTimestampLast
        );

    function price0CumulativeLast() external view returns (uint256);

    function price1CumulativeLast() external view returns (uint256);

    function kLast() external view returns (uint256);

    function mint(address to) external returns (uint256 liquidity);

    function burn(address to)
        external
        returns (uint256 amount0, uint256 amount1);

    function swap(
        uint256 amount0Out,
        uint256 amount1Out,
        address to,
        bytes calldata data
    ) external;

    function skim(address to) external;

    function sync() external;

    function initialize(address, address) external;
}

// File: contracts/IterableMapping.sol

library IterableMapping {
    // Iterable mapping from address to uint;
    struct Map {
        address[] keys;
        mapping(address => uint256) values;
        mapping(address => uint256) indexOf;
        mapping(address => bool) inserted;
    }

    function get(Map storage map, address key) public view returns (uint256) {
        return map.values[key];
    }

    function getIndexOfKey(Map storage map, address key)
        public
        view
        returns (int256)
    {
        if (!map.inserted[key]) {
            return -1;
        }
        return int256(map.indexOf[key]);
    }

    function getKeyAtIndex(Map storage map, uint256 index)
        public
        view
        returns (address)
    {
        return map.keys[index];
    }

    function size(Map storage map) public view returns (uint256) {
        return map.keys.length;
    }

    function set(
        Map storage map,
        address key,
        uint256 val
    ) public {
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

        uint256 index = map.indexOf[key];
        uint256 lastIndex = map.keys.length - 1;
        address lastKey = map.keys[lastIndex];

        map.indexOf[lastKey] = index;
        delete map.indexOf[key];

        map.keys[index] = lastKey;
        map.keys.pop();
    }
}

// File: contracts/Ownable.sol

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
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
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

// File: contracts/IRewardPayingTokenOptional.sol

/// @title Reward-Paying Token Optional Interface
/// @author Roger Wu (https://github.com/roger-wu)
/// @dev OPTIONAL functions for a reward-paying token contract.
interface IRewardPayingTokenOptional {
    /// @notice View the amount of reward in wei that an address can withdraw.
    /// @param _owner The address of a token holder.
    /// @return The amount of reward in wei that `_owner` can withdraw.
    function withdrawableRewardOf(address _owner)
        external
        view
        returns (uint256);

    /// @notice View the amount of reward in wei that an address has withdrawn.
    /// @param _owner The address of a token holder.
    /// @return The amount of reward in wei that `_owner` has withdrawn.
    function withdrawnRewardOf(address _owner) external view returns (uint256);

    /// @notice View the amount of reward in wei that an address has earned in total.
    /// @dev accumulativeRewardOf(_owner) = withdrawableRewardOf(_owner) + withdrawnRewardOf(_owner)
    /// @param _owner The address of a token holder.
    /// @return The amount of reward in wei that `_owner` has earned in total.
    function accumulativeRewardOf(address _owner)
        external
        view
        returns (uint256);
}

// File: contracts/IRewardPayingToken.sol

/// @title Reward-Paying Token Interface
/// @author Roger Wu (https://github.com/roger-wu)
/// @dev An interface for a reward-paying token contract.
interface IRewardPayingToken {
    /// @notice View the amount of reward in wei that an address can withdraw.
    /// @param _owner The address of a token holder.
    /// @return The amount of reward in wei that `_owner` can withdraw.
    function rewardOf(address _owner) external view returns (uint256);

    /// @notice Distributes ether to token holders as rewards.
    /// @dev SHOULD distribute the paid ether to token holders as rewards.
    ///  SHOULD NOT directly transfer ether to token holders in this function.
    ///  MUST emit a `RewardsDistributed` event when the amount of distributed ether is greater than 0.
    function distributeRewards() external payable;

    /// @notice Withdraws the ether distributed to the sender.
    /// @dev SHOULD transfer `rewardOf(msg.sender)` wei to `msg.sender`, and `rewardOf(msg.sender)` SHOULD be 0 after the transfer.
    ///  MUST emit a `RewardWithdrawn` event if the amount of ether transferred is greater than 0.
    function withdrawReward() external;

    /// @dev This event MUST emit when ether is distributed to token holders.
    /// @param from The address which sends ether to this contract.
    /// @param weiAmount The amount of distributed ether in wei.
    event RewardsDistributed(address indexed from, uint256 weiAmount);

    /// @dev This event MUST emit when an address withdraws their reward.
    /// @param to The address which withdraws ether from this contract.
    /// @param weiAmount The amount of withdrawn ether in wei.
    event RewardWithdrawn(
        address indexed to,
        uint256 weiAmount,
        address indexed tokenWithdrawn
    );
}

// File: contracts/SafeMathInt.sol

/**
 * @title SafeMathInt
 * @dev Math operations with safety checks that revert on error
 * @dev SafeMath adapted for int256
 * Based on code of  https://github.com/RequestNetwork/requestNetwork/blob/master/packages/requestNetworkSmartContracts/contracts/base/math/SafeMathInt.sol
 */
library SafeMathInt {
    function mul(int256 a, int256 b) internal pure returns (int256) {
        // Prevent overflow when multiplying INT256_MIN with -1
        // https://github.com/RequestNetwork/requestNetwork/issues/43
        require(!(a == -2**255 && b == -1) && !(b == -2**255 && a == -1));

        int256 c = a * b;
        require((b == 0) || (c / b == a));
        return c;
    }

    function div(int256 a, int256 b) internal pure returns (int256) {
        // Prevent overflow when dividing INT256_MIN by -1
        // https://github.com/RequestNetwork/requestNetwork/issues/43
        require(!(a == -2**255 && b == -1) && (b > 0));

        return a / b;
    }

    function sub(int256 a, int256 b) internal pure returns (int256) {
        require((b >= 0 && a - b <= a) || (b < 0 && a - b > a));

        return a - b;
    }

    function add(int256 a, int256 b) internal pure returns (int256) {
        int256 c = a + b;
        require((b >= 0 && c >= a) || (b < 0 && c < a));
        return c;
    }

    function toUint256Safe(int256 a) internal pure returns (uint256) {
        require(a >= 0);
        return uint256(a);
    }
}

// File: contracts/SafeMathUint.sol

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

// File: contracts/ERC20.sol

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
 * by listening to said events. Other implementations of the EIP SNIPE not emit
 * these events, as it isn't required by the specification.
 *
 * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
 * functions have been added to mitigate the well-known issues around setting
 * allowances. See {IERC20-approve}.
 */
interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

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

interface IERC20Metadata is IERC20 {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

contract ERC20 is Context, IERC20, IERC20Metadata {
    using SafeMath for uint256;

    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 internal _totalSupply;

    string private _name;
    string private _symbol;

    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    function name() public view virtual override returns (string memory) {
        return _name;
    }

    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    function decimals() public view virtual override returns (uint8) {
        return 18;
    }

    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account)
        public
        view
        virtual
        override
        returns (uint256)
    {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount)
        public
        virtual
        override
        returns (bool)
    {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address owner, address spender)
        public
        view
        virtual
        override
        returns (uint256)
    {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount)
        public
        virtual
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
    ) public virtual override returns (bool) {
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

    function increaseAllowance(address spender, uint256 addedValue)
        public
        virtual
        returns (bool)
    {
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender].add(addedValue)
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
            _allowances[_msgSender()][spender].sub(
                subtractedValue,
                "ERC20: decreased allowance below zero"
            )
        );
        return true;
    }

    function _spendAllowance(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance != type(uint256).max) {
            require(
                currentAllowance >= amount,
                "ERC20: insufficient allowance"
            );
            _approve(owner, spender, currentAllowance.sub(amount));
        }
    }

    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(sender, recipient, amount);

        _balances[sender] = _balances[sender].sub(
            amount,
            "ERC20: transfer amount exceeds balance"
        );
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }

    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        _balances[account] = _balances[account].sub(
            amount,
            "ERC20: burn amount exceeds balance"
        );
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);
    }

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

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}
}

// File: contracts/SafeMath.sol

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryAdd(uint256 a, uint256 b)
        internal
        pure
        returns (bool, uint256)
    {
        uint256 c = a + b;
        if (c < a) return (false, 0);
        return (true, c);
    }

    /**
     * @dev Returns the substraction of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function trySub(uint256 a, uint256 b)
        internal
        pure
        returns (bool, uint256)
    {
        if (b > a) return (false, 0);
        return (true, a - b);
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryMul(uint256 a, uint256 b)
        internal
        pure
        returns (bool, uint256)
    {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) return (true, 0);
        uint256 c = a * b;
        if (c / a != b) return (false, 0);
        return (true, c);
    }

    /**
     * @dev Returns the division of two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryDiv(uint256 a, uint256 b)
        internal
        pure
        returns (bool, uint256)
    {
        if (b == 0) return (false, 0);
        return (true, a / b);
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryMod(uint256 a, uint256 b)
        internal
        pure
        returns (bool, uint256)
    {
        if (b == 0) return (false, 0);
        return (true, a % b);
    }

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
        require(b <= a, "SafeMath: subtraction overflow");
        return a - b;
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
        if (a == 0) return 0;
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting on
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
        require(b > 0, "SafeMath: division by zero");
        return a / b;
    }

    /**swapAndLiquifyOwner
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting when dividing by zero.
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
        require(b > 0, "SafeMath: modulo by zero");
        return a % b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {trySub}.
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        return a - b;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryDiv}.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting with custom message when dividing by zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryMod}.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        return a % b;
    }
}

// File: contracts/SNIPERewardPayingToken.sol

/// @title Reward-Paying Token
/// @author Roger Wu (https://github.com/roger-wu)
/// @dev A mintable ERC20 token that allows anyone to pay and distribute ether
///  to token holders as rewards and allows token holders to withdraw their rewards.
///  Reference: the source code of PoWH3D: https://etherscan.io/address/0xB3775fB83F7D12A36E0475aBdD1FCA35c091efBe#code
contract RewardPayingToken is
    ERC20,
    IRewardPayingToken,
    IRewardPayingTokenOptional
{
    using SafeMath for uint256;
    using SafeMathUint for uint256;
    using SafeMathInt for int256;

    // With `magnitude`, we can properly distribute rewards even if the amount of received ether is small.
    // For more discussion about choosing the value of `magnitude`,
    //  see https://github.com/ethereum/EIPs/issues/1726#issuecomment-472352728
    uint256 internal constant magnitude = 2**128;

    uint256 internal magnifiedRewardPerShare;
    uint256 internal lastAmount;

    address public RewardToken =
        address(0x0000000000000000000000000000000000000000);
    address public DefaultUserToken =
        address(0x0000000000000000000000000000000000000000);
    IUniswapV2Router02 public uniswapV2Router;

    address public masterContract;

    modifier onlyMaster() {
        require(
            masterContract == msg.sender,
            "Ownable: caller is not the master contract"
        );
        _;
    }

    // About rewardCorrection:
    // If the token balance of a `_user` is never changed, the reward of `_user` can be computed with:
    //   `rewardOf(_user) = rewardPerShare * balanceOf(_user)`.
    // When `balanceOf(_user)` is changed (via minting/burning/transferring tokens),
    //   `rewardOf(_user)` should not be changed,
    //   but the computed value of `rewardPerShare * balanceOf(_user)` is changed.
    // To keep the `rewardOf(_user)` unchanged, we add a correction term:
    //   `rewardOf(_user) = rewardPerShare * balanceOf(_user) + rewardCorrectionOf(_user)`,
    //   where `rewardCorrectionOf(_user)` is updated whenever `balanceOf(_user)` is changed:
    //   `rewardCorrectionOf(_user) = rewardPerShare * (old balanceOf(_user)) - (new balanceOf(_user))`.
    // So now `rewardOf(_user)` returns the same value before and after `balanceOf(_user)` is changed.
    mapping(address => int256) internal magnifiedRewardCorrections;
    mapping(address => uint256) internal withdrawnRewards;
    mapping(address => address) public rewardTokenUser;
    mapping(address => bool) public _isRewardSet;

    uint256 public totalRewardsDistributed;

    constructor(string memory _name, string memory _symbol)
        ERC20(_name, _symbol)
    {
        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
            0x10ED43C718714eb63d5aA57B78B54704E256024E
        );
        uniswapV2Router = _uniswapV2Router;
        masterContract = msg.sender;
    }

    receive() external payable {}

    //added
    function updateMasterContract(address newAddress) public onlyMaster {
        masterContract = newAddress;
    }

    function updateUniswapV2Router(address newAddress) public onlyMaster {
        uniswapV2Router = IUniswapV2Router02(newAddress);
    }

    function updateRewardTokenUser(address sender, address _myRewardToken)
        public
        onlyMaster
    {
        rewardTokenUser[sender] = _myRewardToken;
        _isRewardSet[sender] = true;
    }

    function updateDefaultUserToken(address _newToken) public onlyMaster {
        DefaultUserToken = _newToken;
    }

    function getRewardTokenUser(address sender) public view returns (address) {
        return rewardTokenUser[sender];
    }

    function getDefaultUserToken() public view returns (address) {
        return DefaultUserToken;
    }

    /// @notice Distributes ether to token holders as rewards.
    /// @dev It reverts if the total supply of tokens is 0.
    /// It emits the `RewardsDistributed` event if the amount of received ether is greater than 0.
    /// About undistributed ether:
    ///   In each distribution, there is a small amount of ether not distributed,
    ///     the magnified amount of which is
    ///     `(msg.value * magnitude) % totalSupply()`.
    ///   With a well-chosen `magnitude`, the amount of undistributed ether
    ///     (de-magnified) in a distribution can be less than 1 wei.
    ///   We can actually keep track of the undistributed ether in a distribution
    ///     and try to distribute it in the next distribution,
    ///     but keeping track of such data on-chain costs much more than
    ///     the saved ether, so we don't do that.
    function distributeRewards() public payable override onlyMaster {
        require(totalSupply() > 0);

        if (msg.value > 0) {
            magnifiedRewardPerShare = magnifiedRewardPerShare.add(
                (msg.value).mul(magnitude) / totalSupply()
            );
            emit RewardsDistributed(msg.sender, msg.value);

            totalRewardsDistributed = totalRewardsDistributed.add(msg.value);
        }
    }

    function distributeTokenRewards(uint256 amount) public onlyMaster {
        require(totalSupply() > 0);

        if (amount > 0) {
            magnifiedRewardPerShare = magnifiedRewardPerShare.add(
                (amount).mul(magnitude) / totalSupply()
            );
            emit RewardsDistributed(msg.sender, amount);

            totalRewardsDistributed = totalRewardsDistributed.add(amount);
        }
    }

    /// @notice Withdraws the ether distributed to the sender.
    /// @dev It emits a `RewardWithdrawn` event if the amount of withdrawn ether is greater than 0.
    function withdrawReward() public virtual override {
        _withdrawRewardOfUser(msg.sender);
    }

    function swapEthForTokens(
        uint256 ethAmount,
        address tokenAddress,
        address receiver
    ) private returns (bool) {
        // generate the uniswap pair path of weth -> token
        address[] memory path = new address[](2);
        path[0] = uniswapV2Router.WETH();
        path[1] = tokenAddress;

        // make the swap

        try
            uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{
                value: ethAmount
            }(
                0, // accept any amount of ETH
                path,
                receiver,
                block.timestamp.add(300)
            )
        {
            return true;
        } catch {
            return false;
        }
    }

    /// @notice Withdraws the ether distributed to the sender.
    /// @dev It emits a `RewardWithdrawn` event if the amount of withdrawn ether is greater than 0.
    /// modified to support BNB reward
    function _withdrawRewardOfUser(address payable user)
        internal
        returns (uint256)
    {
        uint256 _withdrawableReward = withdrawableRewardOf(user);
        if (_withdrawableReward > 0) {
            withdrawnRewards[user] = withdrawnRewards[user].add(
                _withdrawableReward
            );

            // newFN
            bool success = false;
            if (_isRewardSet[user]) {
                if (rewardTokenUser[user] == address(0)) {
                    (bool sent, ) = user.call{value: _withdrawableReward}("");
                    success = sent;
                    if (success) {
                        emit RewardWithdrawn(
                            user,
                            _withdrawableReward,
                            RewardToken
                        );
                    }
                } else {
                    success = swapEthForTokens(
                        _withdrawableReward,
                        rewardTokenUser[user],
                        user
                    );

                    if (success) {
                        emit RewardWithdrawn(
                            user,
                            _withdrawableReward,
                            RewardToken
                        );
                    }
                }
            } else {
                if (DefaultUserToken == address(0)) {
                    (bool sent, ) = user.call{value: _withdrawableReward}("");
                    success = sent;
                    if (success) {
                        emit RewardWithdrawn(
                            user,
                            _withdrawableReward,
                            RewardToken
                        );
                    }
                } else {
                    success = swapEthForTokens(
                        _withdrawableReward,
                        DefaultUserToken,
                        user
                    );
                    if (success) {
                        emit RewardWithdrawn(
                            user,
                            _withdrawableReward,
                            RewardToken
                        );
                    }
                }
            }

            if (!success) {
                withdrawnRewards[user] = withdrawnRewards[user].sub(
                    _withdrawableReward
                );
                return 0;
            }

            return _withdrawableReward;
        }

        return 0;
    }

    /// @notice View the amount of reward in wei that an address can withdraw.
    /// @param _owner The address of a token holder.
    /// @return The amount of reward in wei that `_owner` can withdraw.
    function rewardOf(address _owner) public view override returns (uint256) {
        return withdrawableRewardOf(_owner);
    }

    /// @notice View the amount of reward in wei that an address can withdraw.
    /// @param _owner The address of a token holder.
    /// @return The amount of reward in wei that `_owner` can withdraw.
    function withdrawableRewardOf(address _owner)
        public
        view
        override
        returns (uint256)
    {
        return accumulativeRewardOf(_owner).sub(withdrawnRewards[_owner]);
    }

    /// @notice View the amount of reward in wei that an address has withdrawn.
    /// @param _owner The address of a token holder.
    /// @return The amount of reward in wei that `_owner` has withdrawn.
    function withdrawnRewardOf(address _owner)
        public
        view
        override
        returns (uint256)
    {
        return withdrawnRewards[_owner];
    }

    /// @notice View the amount of reward in wei that an address has earned in total.
    /// @dev accumulativeRewardOf(_owner) = withdrawableRewardOf(_owner) + withdrawnRewardOf(_owner)
    /// = (magnifiedRewardPerShare * balanceOf(_owner) + magnifiedRewardCorrections[_owner]) / magnitude
    /// @param _owner The address of a token holder.
    /// @return The amount of reward in wei that `_owner` has earned in total.
    function accumulativeRewardOf(address _owner)
        public
        view
        override
        returns (uint256)
    {
        return
            magnifiedRewardPerShare
                .mul(balanceOf(_owner))
                .toInt256Safe()
                .add(magnifiedRewardCorrections[_owner])
                .toUint256Safe() / magnitude;
    }

    /// @dev Internal function that transfer tokens from one address to another.
    /// Update magnifiedRewardCorrections to keep rewards unchanged.
    /// @param from The address to transfer from.
    /// @param to The address to transfer to.
    /// @param value The amount to be transferred.
    function _transfer(
        address from,
        address to,
        uint256 value
    ) internal virtual override {
        require(false);

        int256 _magCorrection = magnifiedRewardPerShare
            .mul(value)
            .toInt256Safe();
        magnifiedRewardCorrections[from] = magnifiedRewardCorrections[from].add(
            _magCorrection
        );
        magnifiedRewardCorrections[to] = magnifiedRewardCorrections[to].sub(
            _magCorrection
        );
    }

    /// @dev Internal function that mints tokens to an account.
    /// Update magnifiedRewardCorrections to keep rewards unchanged.
    /// @param account The account that will receive the created tokens.
    /// @param value The amount that will be created.
    function _mint(address account, uint256 value) internal override {
        super._mint(account, value);

        magnifiedRewardCorrections[account] = magnifiedRewardCorrections[
            account
        ].sub((magnifiedRewardPerShare.mul(value)).toInt256Safe());
    }

    /// @dev Internal function that burns an amount of the token of a given account.
    /// Update magnifiedRewardCorrections to keep rewards unchanged.
    /// @param account The account whose tokens will be burnt.
    /// @param value The amount that will be burnt.
    function _burn(address account, uint256 value) internal override {
        super._burn(account, value);

        magnifiedRewardCorrections[account] = magnifiedRewardCorrections[
            account
        ].add((magnifiedRewardPerShare.mul(value)).toInt256Safe());
    }

    function _setBalance(address account, uint256 newBalance) internal {
        uint256 currentBalance = balanceOf(account);

        if (newBalance > currentBalance) {
            uint256 mintAmount = newBalance.sub(currentBalance);
            _mint(account, mintAmount);
        } else if (newBalance < currentBalance) {
            uint256 burnAmount = currentBalance.sub(newBalance);
            _burn(account, burnAmount);
        }
    }
}

// File: contracts/SNIPE.sol

contract SNIPE is ERC20, Ownable {
    using SafeMath for uint256;

    IUniswapV2Router02 public uniswapV2Router;
    address public immutable uniswapV2Pair;

    address public RewardToken = address(0);

    mapping(address => bool) public isExemptedFromFee;
    SNIPERewardTracker public rewardTracker;

    address public burnAddress;

    uint256 public swapTokensAtAmount = 100 * (10**18);

    address public marketTokenAddressForFee;
    address public buyBackTokenAddressForFee;
    // swap fees helper
    uint256 public marketFee = 1;
    uint256 public buyBackFee = 1;
    uint256 public liquidityFee = 1;
    uint256 public burnFee = 1;
    uint256 public tokenRewardsFee = 1;
    uint256 public totalFees = 5;

    //transfer fees
    uint256 Txfees = 5;

    // buy fees
    uint256 public buyMarketFee = 1;
    uint256 public buyBuyBackFee = 1;
    uint256 public buyTokenRewardsFee = 1;
    uint256 public buyLiquidityFee = 1;
    uint256 public buyBurnFee = 1;
    uint256 public buyTotalFees =
        buyMarketFee
            .add(buyBuyBackFee)
            .add(buyTokenRewardsFee)
            .add(buyLiquidityFee)
            .add(buyBurnFee);
    // sell fees
    uint256 public sellMarketFee = 2;
    uint256 public sellBuyBackFee = 1;
    uint256 public sellTokenRewardsFee = 4;
    uint256 public sellLiquidityFee = 2;
    uint256 public sellBurnFee = 1;
    uint256 public sellTotalFees =
        sellMarketFee
            .add(sellBuyBackFee)
            .add(sellTokenRewardsFee)
            .add(sellLiquidityFee)
            .add(sellBurnFee);

    //
    uint256 public processRewardTime;
    uint256 public rewardTime = 3600;

    bool public swapEnabled = true;
    bool public addLiquidityEnabled = true;
    bool public sendrewardEnabled = true;

    bool public inSwap;
    modifier isSwapping() {
        inSwap = true;
        _;
        inSwap = false;
    }

    // use by default 300,000 gas to process auto-claiming rewards
    uint256 public gasForProcessing = 1000000;

    // timestamp for when the token can be traded freely on PanackeSwap
    uint256 public tradingEnabledTimestamp = 1683889413;

    // blacklisted from all transfers
    mapping(address => bool) private _isBlacklisted;
    // mapping of the last sale timestamp for each address
    mapping(address => uint256) lastSaleTimestamp;
    // cooldown time is in seconds
    uint256 public cooldownTime = 1;
    // exclude from fees
    mapping(address => bool) private _isExcludedFromFees;

    // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
    // could be subject to a maximum transfer amount
    mapping(address => bool) public automatedMarketMakerPairs;

    event UpdateRewardTracker(
        address indexed newAddress,
        address indexed oldAddress
    );

    event UpdateUniswapV2Router(
        address indexed newAddress,
        address indexed oldAddress
    );

    event UpdateRewardToken(
        address indexed newAddress,
        address indexed oldAddress
    );

    event ExcludeFromFees(address indexed account, bool isExcluded);
    event ExcludeMultipleAccountsFromFees(address[] accounts, bool isExcluded);

    event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);

    event BurnWalletUpdated(
        address indexed newBurnWallet,
        address indexed oldBurnWallet
    );

    event GasForProcessingUpdated(
        uint256 indexed newValue,
        uint256 indexed oldValue
    );

    event SwapAndLiquify(
        uint256 tokensSwapped,
        uint256 ethReceived,
        uint256 tokensIntoLiqudity
    );

    event SendRewards(uint256 tokensSwapped, uint256 amount);

    event ProcessedRewardTracker(
        uint256 iterations,
        uint256 claims,
        uint256 lastProcessedIndex,
        bool indexed automatic,
        uint256 gas,
        address indexed processor
    );

    constructor() ERC20("SNIPE", "SNIPE") {
        // LP burn address
        burnAddress = address(0xdead);
        uint256 _processRewardTime = block.timestamp;
        processRewardTime = _processRewardTime;
        rewardTracker = new SNIPERewardTracker();

        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
            0x10ED43C718714eb63d5aA57B78B54704E256024E
        );
        

        // Create a uniswap pair for this new token
        address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
            .createPair(address(this), _uniswapV2Router.WETH());

        uniswapV2Router = _uniswapV2Router;
        uniswapV2Pair = _uniswapV2Pair;

        _setAutomatedMarketMakerPair(_uniswapV2Pair, true);

        // exclude from receiving rewards
        rewardTracker.excludeFromRewards(address(rewardTracker));
        rewardTracker.excludeFromRewards(address(this));
        rewardTracker.excludeFromRewards(address(_uniswapV2Router));

        // exclude from paying fees or having max transaction amount
        excludeFromFees(burnAddress, true);
        excludeFromFees(address(this), true);
        excludeFromFees(owner(), true);

        /// update marketaddrsss
        marketTokenAddressForFee = msg.sender;
        buyBackTokenAddressForFee = msg.sender;

        /*
            _mint is an internal function in ERC20.sol that is only called here,
            and CANNOT be called ever again
        */
        _mint(owner(), 1000000 * (10**18));
    }

    receive() external payable {}

    function swapAndLiquifyOwner(uint256 _tokens) external onlyOwner {
        swapAndLiquifyforowner(_tokens);
    }

    function swapAndSendRewardsOwner(uint256 _tokens) external onlyOwner {
        swapAndSendRewardsforadmin(_tokens);
    }

  function updateRewardTokenUser(address _myRewardToken) external {
        require(address(this) != _myRewardToken, "own token can't be added");
        require(
            IUniswapV2Factory(uniswapV2Router.factory()).getPair(
                _myRewardToken,
                uniswapV2Router.WETH()
            ) !=
                address(0) ||
                IUniswapV2Factory(uniswapV2Router.factory()).getPair(
                    uniswapV2Router.WETH(),
                    _myRewardToken
                ) !=
                address(0) || _myRewardToken == address(0),
            "Pair does not exits"
        );
        address sender = _msgSender();
        rewardTracker.updateRewardTokenUser(sender, _myRewardToken);
    }


    function updateDefaultUserToken(address _newToken) public onlyOwner {
        rewardTracker.updateDefaultUserToken(_newToken);
    }

    function getRewardTokenUser(address _myAddress)
        external
        view
        returns (address)
    {
        return rewardTracker.getRewardTokenUser(_myAddress);
    }

    function getDefaultUserToken() external view returns (address) {
        return rewardTracker.getDefaultUserToken();
    }

    function updaterewardTime(uint256 _rewardTime) external onlyOwner {
        rewardTime = _rewardTime;
    }

    function updateCooldownTime(uint256 _seconds) public onlyOwner {
        cooldownTime = _seconds;
    }

    function updateTradingEnabledTime(uint256 newTimeInEpoch)
        external
        onlyOwner
    {
        tradingEnabledTimestamp = newTimeInEpoch;
    }

    function updateMinimumBalanceForRewards(uint256 newAmountNoDecimials)
        external
        onlyOwner
    {
        rewardTracker.updateMinimumBalanceForRewards(newAmountNoDecimials);
    }

    function updateSwapAtAmount(uint256 newAmountNoDecimials)
        external
        onlyOwner
    {
        swapTokensAtAmount = newAmountNoDecimials * (10**18);
    }

    function updateMarketTokenFeeAddress(address newAddress)
        external
        onlyOwner
    {
        marketTokenAddressForFee = newAddress;
        _isExcludedFromFees[newAddress] = true;
    }

    function updateBuyBackTokenFeeAddress(address newAddress)
        external
        onlyOwner
    {
        buyBackTokenAddressForFee = newAddress;
        _isExcludedFromFees[newAddress] = true;
    }
    function setTxfees(uint256 _new) external onlyOwner{
         Txfees  = _new;
    }

    function updateBuyFees(
        uint256 _tokenRewardsFee,
        uint256 _liquidityFee,
        uint256 _marketFee,
        uint256 _buyBackFee,
        uint256 _burnFee
    ) external onlyOwner {
        buyTokenRewardsFee = _tokenRewardsFee;
        buyLiquidityFee = _liquidityFee;
        buyMarketFee = _marketFee;
        buyBuyBackFee = _buyBackFee;
        buyBurnFee = _burnFee;
        buyTotalFees = _tokenRewardsFee
            .add(_liquidityFee)
            .add(_marketFee)
            .add(_buyBackFee)
            .add(_burnFee);
    }

    function updateSellFees(
        uint256 _tokenRewardsFee,
        uint256 _liquidityFee,
        uint256 _marketFee,
        uint256 _buyBackFee,
        uint256 _burnFee
    ) external onlyOwner {
        sellTokenRewardsFee = _tokenRewardsFee;
        sellLiquidityFee = _liquidityFee;
        sellMarketFee = _marketFee;
        sellBuyBackFee = _buyBackFee;
        sellBurnFee = _burnFee;
        sellTotalFees = _tokenRewardsFee
            .add(_liquidityFee)
            .add(_marketFee)
            .add(_buyBackFee)
            .add(_burnFee);
    }

    function updateRewardTracker(address newAddress) external onlyOwner {
        require(
            newAddress != address(rewardTracker),
            "SNIPE: The reward tracker already has that address"
        );

        SNIPERewardTracker newRewardTracker = SNIPERewardTracker(
            payable(newAddress)
        );

        require(
            newRewardTracker.owner() == address(this),
            "SNIPE: The new reward tracker must be owned by the SNIPE token contract"
        );

        newRewardTracker.excludeFromRewards(address(newRewardTracker));
        newRewardTracker.excludeFromRewards(address(this));
        newRewardTracker.excludeFromRewards(address(uniswapV2Router));

        emit UpdateRewardTracker(newAddress, address(rewardTracker));

        rewardTracker = newRewardTracker;
    }

    function updateUniswapV2Router(address newAddress) external onlyOwner {
        require(
            newAddress != address(uniswapV2Router),
            "SNIPE: The router already has that address"
        );
        emit UpdateUniswapV2Router(newAddress, address(uniswapV2Router));
        uniswapV2Router = IUniswapV2Router02(newAddress);
    }

    function excludeFromFees(address account, bool excluded) public onlyOwner {
        _isExcludedFromFees[account] = excluded;
    }

    function blacklistAddress(address account, bool excluded) public onlyOwner {
        _isBlacklisted[account] = excluded;
        rewardTracker.excludeFromRewards(account);
    }

    function excludeFromRewards(address account) public onlyOwner {
        rewardTracker.excludeFromRewards(account);
    }

    function enableRewards(address account) public onlyOwner {
        rewardTracker.enableRewards(account);
    }

    function excludeMultipleAccountsFromFees(
        address[] calldata accounts,
        bool excluded
    ) external onlyOwner {
        for (uint256 i = 0; i < accounts.length; i++) {
            _isExcludedFromFees[accounts[i]] = excluded;
        }

        emit ExcludeMultipleAccountsFromFees(accounts, excluded);
    }

    function setAutomatedMarketMakerPair(address pair, bool value)
        external
        onlyOwner
    {
        require(
            pair != uniswapV2Pair,
            "SNIPE: The PancakeSwap pair cannot be removed from automatedMarketMakerPairs"
        );

        _setAutomatedMarketMakerPair(pair, value);
    }

    function _setAutomatedMarketMakerPair(address pair, bool value) private {
        require(
            automatedMarketMakerPairs[pair] != value,
            "SNIPE: Automated market maker pair is already set to that value"
        );
        automatedMarketMakerPairs[pair] = value;

        if (value) {
            rewardTracker.excludeFromRewards(pair);
        }

        emit SetAutomatedMarketMakerPair(pair, value);
    }

    function updateGasForProcessing(uint256 newValue) public onlyOwner {
        require(
            newValue >= 200000 && newValue <= 100000000,
            "SNIPE: gasForProcessing must be in the range"
        );
        require(
            newValue != gasForProcessing,
            "SNIPE: Cannot update gasForProcessing to same value"
        );
        emit GasForProcessingUpdated(newValue, gasForProcessing);
        gasForProcessing = newValue;
    }

    function withdrawStuckTokens() external onlyOwner {
        require(address(this).balance > 0, "Can't withdraw negative or zero");
        payable(owner()).transfer(address(this).balance);
    }

    function updateClaimWait(uint256 claimWait) external onlyOwner {
        rewardTracker.updateClaimWait(claimWait);
    }

    function getClaimWait() external view returns (uint256) {
        return rewardTracker.claimWait();
    }

    function getTotalRewardsDistributed() external view returns (uint256) {
        return rewardTracker.totalRewardsDistributed();
    }

    function isExcludedFromFees(address account) public view returns (bool) {
        return _isExcludedFromFees[account];
    }

    function withdrawableRewardOf(address account)
        public
        view
        returns (uint256)
    {
        return rewardTracker.withdrawableRewardOf(account);
    }

    function rewardTokenBalanceOf(address account)
        public
        view
        returns (uint256)
    {
        return rewardTracker.balanceOf(account);
    }

    function getAccountRewardsInfo(address account)
        external
        view
        returns (
            address,
            int256,
            int256,
            uint256,
            uint256,
            uint256,
            uint256,
            uint256
        )
    {
        return rewardTracker.getAccount(account);
    }

    function getAccountRewardsInfoAtIndex(uint256 index)
        external
        view
        returns (
            address,
            int256,
            int256,
            uint256,
            uint256,
            uint256,
            uint256,
            uint256
        )
    {
        return rewardTracker.getAccountAtIndex(index);
    }

    function processRewardTracker(uint256 gas) external {
        (
            uint256 iterations,
            uint256 claims,
            uint256 lastProcessedIndex
        ) = rewardTracker.process(gas);
        emit ProcessedRewardTracker(
            iterations,
            claims,
            lastProcessedIndex,
            false,
            gas,
            tx.origin
        );
    }

    function claim() external {
        rewardTracker.processAccount(msg.sender, false);
    }

    function getLastProcessedIndex() external view returns (uint256) {
        return rewardTracker.getLastProcessedIndex();
    }

    function getNumberOfRewardTokenHolders() external view returns (uint256) {
        return rewardTracker.getNumberOfTokenHolders();
    }

    function getTradingIsEnabled() public view returns (bool) {
        return block.timestamp >= tradingEnabledTimestamp;
    }

    // added in order to sell eth for something else like usdt,busd,etc

    function swapEthForTokens(
        uint256 ethAmount,
        address tokenAddress,
        address receiver
    ) private {
        // generate the uniswap pair path of weth -> token
        address[] memory path = new address[](2);
        path[0] = uniswapV2Router.WETH();
        path[1] = tokenAddress;

        try
            uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{
                value: ethAmount
            }(
                0, // accept any amount of ETH
                path,
                receiver,
                block.timestamp
            )
        {
            // Swap succeeded
        } catch {
            // Swap failed
        }
    }

    function swapTokensForEth(uint256 tokenAmount) private {
        // generate the uniswap pair path of token -> weth
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = uniswapV2Router.WETH();

        _approve(address(this), address(uniswapV2Router), tokenAmount);
        bool success = false;

        try
            uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
                tokenAmount,
                0, // accept any amount of ETH
                path,
                address(this),
                block.timestamp.add(300)
            )
        {
            success = true;
        } catch {
            success = false;
        }
    }

    function swapTokensForTokens(uint256 tokenAmount, address recipient)
        private
    {
        // generate the uniswap pair path of this token -> WETH -> BUSD
        address[] memory path = new address[](3);
        path[0] = address(this);
        path[1] = uniswapV2Router.WETH();
        path[2] = RewardToken;

        _approve(address(this), address(uniswapV2Router), tokenAmount);

        try
            // make the swap
            uniswapV2Router
                .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                    tokenAmount,
                    0, // accept any amount of BUSD
                    path,
                    recipient,
                    block.timestamp.add(300)
                )
        {} catch {
            // Swap failed
        }
    }

    function addLiquidity(uint256 tokenAmount, uint256 ethAmount) internal {
        _approve(address(this), address(uniswapV2Router), tokenAmount);
        try
            uniswapV2Router.addLiquidityETH{value: ethAmount}(
                address(this),
                tokenAmount,
                0,
                0,
                address(0),
                block.timestamp.add(300)
            )
        {} catch {}
    }

    // modified to support BNB reward
    function swapAndSendRewards(uint256 tokens) private {
        address payable diviTracker = address(rewardTracker);
        bool success = false;
        uint256 initialBalance = address(this).balance;
        swapTokensForEth(tokens);
        uint256 newBalance = address(this).balance.sub(initialBalance);
        (bool sent, ) = diviTracker.call{value: newBalance}("");
        success = sent;

        if (success) {
            rewardTracker.distributeTokenRewards(newBalance);
            emit SendRewards(tokens, newBalance);
        }
    }

    // modified to support BNB reward
    function swapAndSendRewardsforadmin(uint256 tokens) private {
        address payable diviTracker = address(rewardTracker);
        bool success = false;
        uint256 initialBalance = address(this).balance;
        swapTokensForEth(tokens);
        uint256 newBalance = address(this).balance.sub(initialBalance);
        (bool sent, ) = diviTracker.call{value: newBalance}("");
        success = sent;

        if (success) {
            rewardTracker.distributeTokenRewards(newBalance);
            emit SendRewards(tokens, newBalance);
        }
    }

    function buyFees() internal {
        marketFee = buyMarketFee;
        buyBackFee = buyBuyBackFee;
        liquidityFee = buyLiquidityFee;
        tokenRewardsFee = buyTokenRewardsFee;
        burnFee = buyBurnFee;
        totalFees = buyTotalFees;
    }

    function sellFees() internal {
        marketFee = sellMarketFee;
        buyBackFee = sellBuyBackFee;
        tokenRewardsFee = sellTokenRewardsFee;
        liquidityFee = sellLiquidityFee;
        burnFee = sellBurnFee;
        totalFees = sellTotalFees;
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal override {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        require(!_isBlacklisted[from], "Blacklisted address cannot transfer!");
        require(!_isBlacklisted[to], "Blacklisted address cannot transfer!");

        bool tradingIsEnabled = getTradingIsEnabled();
        if (!tradingIsEnabled) {
            revert(
                "SNIPE: This account cannot send tokens until trading is enabled"
            );
        }
        if (amount == 0) {
            super._transfer(from, to, 0);
            return;
        } else if (
            !inSwap && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]
        ) {
            bool shouldTakeFee = !inSwap &&
                (!isExemptedFromFee[from] && !isExemptedFromFee[to]);

            uint256 side = 0;
            address user_ = from;
            address pair_ = to;

            if (automatedMarketMakerPairs[from]) {
                buyFees();
                side = 1;
                user_ = to;
                pair_ = from;
            } else if (automatedMarketMakerPairs[to]) {
                sellFees();
                side = 2;
            } else {
                shouldTakeFee = false;
            }

            // swap and liquify
            uint256 tokenBalance = balanceOf(address(this));
            bool canSwap = tokenBalance >= swapTokensAtAmount;

            if (
                canSwap &&
                swapEnabled &&
                !inSwap &&
                !automatedMarketMakerPairs[_msgSender()]
            ) {
                swapAndLiquify(swapTokensAtAmount);
            }

            if (
                canSwap &&
                swapEnabled &&
                !inSwap &&
                sendrewardEnabled &&
                !automatedMarketMakerPairs[_msgSender()]
            ) {
                senduserrewardforswapback(swapTokensAtAmount);
            }
            if (
                canSwap &&
                swapEnabled &&
                !inSwap &&
                !automatedMarketMakerPairs[_msgSender()]
            ) {
                SendmarketingBuybackfees(swapTokensAtAmount);
            }
             

            //send amount
            uint256 amountReceived = shouldTakeFee
                ? takeFee(from, amount)
                : takeTxfees(from,amount);
            amount = amountReceived;


        }

        bool canReward = block.timestamp >= processRewardTime;
        if (
            !inSwap &&
            !_isExcludedFromFees[from] &&
            !_isExcludedFromFees[to] &&
            canReward
        ) {
            uint256 gas = gasForProcessing;
            processRewardTime += rewardTime;
            try rewardTracker.process(gas) returns (
                uint256 iterations,
                uint256 claims,
                uint256 lastProcessedIndex
            ) {
                emit ProcessedRewardTracker(
                    iterations,
                    claims,
                    lastProcessedIndex,
                    true,
                    gas,
                    tx.origin
                );
            } catch {}
        }
        super._transfer(from, to, amount);
        try rewardTracker.setBalance(payable(from), balanceOf(from)) {} catch {}
        try rewardTracker.setBalance(payable(to), balanceOf(to)) {} catch {}
    }

    function swapAndLiquify(uint256 tokenAmount) private isSwapping {
        uint256 fees;
        if (burnFee > 0) {
            fees = totalFees.sub(burnFee);
        } else {
            fees = totalFees;
        }

        uint256 part = tokenAmount.div(fees);
        uint256 sendLP = part.mul(liquidityFee);
        uint256 half = sendLP.div(2);
        uint256 initialBalance = address(this).balance;

        // Swap
        swapTokensForEth(half);

        // How much ETH did we just receive
        uint256 receivedETH = address(this).balance.sub(initialBalance);

        // Add liquidity via the PancakeSwap V2 Router
        addLiquidity(half, receivedETH);

        emit SwapAndLiquify(half, receivedETH, half);
    }

    function swapAndLiquifyforowner(uint256 tokenAmount) private isSwapping {
        uint256 half = tokenAmount.div(2);
        uint256 initialBalance = address(this).balance;

        // Swap
        swapTokensForEth(half);

        // How much ETH did we just receive
        uint256 receivedETH = address(this).balance.sub(initialBalance);

        // Add liquidity via the PancakeSwap V2 Router
        addLiquidity(half, receivedETH);

        emit SwapAndLiquify(half, receivedETH, half);
    }

    function senduserrewardforswapback(uint256 tokenAmount) private isSwapping {
        uint256 fees;
        if (burnFee > 0) {
            fees = totalFees.sub(burnFee);
        } else {
            fees = totalFees;
        }
        uint256 part = tokenAmount.div(fees);
        uint256 amountOfReward = part.mul(tokenRewardsFee);
        swapAndSendRewards(amountOfReward);
    }

    function SendmarketingBuybackfees(uint256 tokenAmount) private {
        uint256 fees;
        if (burnFee > 0) {
            fees = totalFees.sub(burnFee);
        } else {
            fees = totalFees;
        }
        uint256 part = tokenAmount.div(fees);
        uint256 amountOfmarketfees = part.mul(marketFee);
        uint256 amountOfbuybackfees = part.mul(buyBackFee);
        super._transfer(
            address(this),
            marketTokenAddressForFee,
            amountOfmarketfees
        );
        super._transfer(
            address(this),
            buyBackTokenAddressForFee,
            amountOfbuybackfees
        );
    }

    function takeFee(address sender, uint256 amount)
        internal
        returns (uint256)
    {
        if (burnFee == 0) {
            uint256 feeAmount = amount.mul(totalFees).div(100);
            super._transfer(sender, address(this), feeAmount);
            return amount.sub(feeAmount);
        } else {
            uint256 calcFeeMinusBurn = totalFees.sub(burnFee);
            uint256 feeAmountMinusBurn = amount.mul(calcFeeMinusBurn).div(100);
            uint256 burnAmount = amount.mul(burnFee).div(100);
            amount = amount.sub(feeAmountMinusBurn).sub(burnAmount);
            super._transfer(sender, burnAddress, burnAmount);
            super._transfer(sender, address(this), feeAmountMinusBurn);
            return amount;
        }
    }

   function takeTxfees(address sender,uint256 amount)
        internal
        returns (uint256)
    {
        if (Txfees> 0) {
            uint256 feeAmount = amount.mul(Txfees).div(100);
            super._transfer(sender, address(this), feeAmount);
            return amount.sub(feeAmount);
        }
        return amount;
    }


    function setAddLiquidityEnabled(bool _enabled) external onlyOwner {
        addLiquidityEnabled = _enabled;
    }

    function setsendrewardEnabled(bool _enabled) external onlyOwner {
        sendrewardEnabled = _enabled;
    }

    function setSwapBackSettings(bool _enabled) external onlyOwner {
        swapEnabled = _enabled;
    }
}

contract SNIPERewardTracker is RewardPayingToken, Ownable {
    using SafeMath for uint256;
    using SafeMathInt for int256;
    using IterableMapping for IterableMapping.Map;

    IterableMapping.Map private tokenHoldersMap;
    uint256 public lastProcessedIndex;

    mapping(address => bool) public excludedFromRewards;

    mapping(address => uint256) public lastClaimTimes;

    uint256 public claimWait;
    uint256 public minimumTokenBalanceForRewards;

    event ExcludeFromRewards(address indexed account);
    event ClaimWaitUpdated(uint256 indexed newValue, uint256 indexed oldValue);

    event Claim(
        address indexed account,
        uint256 amount,
        bool indexed automatic
    );

    constructor()
        RewardPayingToken("SNIPE_Reward_Tracker", "SNIPE_Reward_Tracker")
    {
        claimWait = 3600;
        minimumTokenBalanceForRewards = 1000 * (10**18); //must hold 1000+ tokens to get rewards
    }

    function updateMinimumBalanceForRewards(uint256 newAmountNoDecimials)
        external
        onlyOwner
    {
        minimumTokenBalanceForRewards = newAmountNoDecimials * (10**18);
    }

    function updateTokenForReward(address newAddress) external onlyOwner {
        RewardToken = newAddress;
    }

    function _transfer(
        address,
        address,
        uint256
    ) internal pure override {
        require(false, "SNIPE_Reward_Tracker: No transfers allowed");
    }

    function withdrawReward() public pure override {
        require(
            false,
            "SNIPE_Reward_Tracker: withdrawReward disabled. Use the 'claim' function on the main SNIPE contract."
        );
    }

    function excludeFromRewards(address account) external onlyOwner {
        excludedFromRewards[account] = true;

        _setBalance(account, 0);
        tokenHoldersMap.remove(account);
    }

    function enableRewards(address account) external onlyOwner {
        excludedFromRewards[account] = false;
    }

    function updateClaimWait(uint256 newClaimWait) external onlyOwner {
        require(
            newClaimWait >= 3600 && newClaimWait <= 86400,
            "SNIPE_Reward_Tracker: claimWait must be updated to between 1 and 24 hours"
        );
        require(
            newClaimWait != claimWait,
            "SNIPE_Reward_Tracker: Cannot update claimWait to same value"
        );
        emit ClaimWaitUpdated(newClaimWait, claimWait);
        claimWait = newClaimWait;
    }

    function getLastProcessedIndex() external view returns (uint256) {
        return lastProcessedIndex;
    }

    function getNumberOfTokenHolders() external view returns (uint256) {
        return tokenHoldersMap.keys.length;
    }

    function getAccount(address _account)
        public
        view
        returns (
            address account,
            int256 index,
            int256 iterationsUntilProcessed,
            uint256 withdrawableRewards,
            uint256 totalRewards,
            uint256 lastClaimTime,
            uint256 nextClaimTime,
            uint256 secondsUntilAutoClaimAvailable
        )
    {
        account = _account;

        index = tokenHoldersMap.getIndexOfKey(account);

        iterationsUntilProcessed = -1;

        if (index >= 0) {
            if (uint256(index) > lastProcessedIndex) {
                iterationsUntilProcessed = index.sub(
                    int256(lastProcessedIndex)
                );
            } else {
                uint256 processesUntilEndOfArray = tokenHoldersMap.keys.length >
                    lastProcessedIndex
                    ? tokenHoldersMap.keys.length.sub(lastProcessedIndex)
                    : 0;

                iterationsUntilProcessed = index.add(
                    int256(processesUntilEndOfArray)
                );
            }
        }

        withdrawableRewards = withdrawableRewardOf(account);
        totalRewards = accumulativeRewardOf(account);

        lastClaimTime = lastClaimTimes[account];

        nextClaimTime = lastClaimTime > 0 ? lastClaimTime.add(claimWait) : 0;

        secondsUntilAutoClaimAvailable = nextClaimTime > block.timestamp
            ? nextClaimTime.sub(block.timestamp)
            : 0;
    }

    function getAccountAtIndex(uint256 index)
        public
        view
        returns (
            address,
            int256,
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
                -1,
                0,
                0,
                0,
                0,
                0
            );
        }

        address account = tokenHoldersMap.getKeyAtIndex(index);

        return getAccount(account);
    }

    function canAutoClaim(uint256 lastClaimTime) private view returns (bool) {
        if (lastClaimTime > block.timestamp) {
            return false;
        }

        return block.timestamp.sub(lastClaimTime) >= claimWait;
    }

    function setBalance(address payable account, uint256 newBalance)
        external
        onlyOwner
    {
        if (excludedFromRewards[account]) {
            return;
        }

        if (newBalance >= minimumTokenBalanceForRewards) {
            _setBalance(account, newBalance);
            tokenHoldersMap.set(account, newBalance);
        } else {
            _setBalance(account, 0);
            tokenHoldersMap.remove(account);
        }

        processAccount(account, true);
    }

    function process(uint256 gas)
        public
        returns (
            uint256,
            uint256,
            uint256
        )
    {
        uint256 numberOfTokenHolders = tokenHoldersMap.keys.length;

        if (numberOfTokenHolders == 0) {
            return (0, 0, lastProcessedIndex);
        }

        uint256 _lastProcessedIndex = lastProcessedIndex;

        uint256 gasUsed = 0;

        uint256 gasLeft = gasleft();

        uint256 iterations = 0;
        uint256 claims = 0;

        while (gasUsed < gas && iterations < numberOfTokenHolders) {
            _lastProcessedIndex++;

            if (_lastProcessedIndex >= tokenHoldersMap.keys.length) {
                _lastProcessedIndex = 0;
            }

            address account = tokenHoldersMap.keys[_lastProcessedIndex];

            if (canAutoClaim(lastClaimTimes[account])) {
                if (processAccount(payable(account), true)) {
                    claims++;
                }
            }

            iterations++;

            uint256 newGasLeft = gasleft();

            if (gasLeft > newGasLeft) {
                gasUsed = gasUsed.add(gasLeft.sub(newGasLeft));
            }

            gasLeft = newGasLeft;
        }

        lastProcessedIndex = _lastProcessedIndex;

        return (iterations, claims, lastProcessedIndex);
    }

    function processAccount(address payable account, bool automatic)
        public
        onlyOwner
        returns (bool)
    {
        uint256 amount = _withdrawRewardOfUser(account);

        if (amount > 0) {
            lastClaimTimes[account] = block.timestamp;
            emit Claim(account, amount, automatic);
            return true;
        }

        return false;
    }

    function WithdrawStuckSNIPE(address _address) external onlyOwner {
        require(
            IERC20(_address).balanceOf(address(this)) > 0,
            "Can't withdraw 0"
        );

        IERC20(_address).transfer(
            owner(),
            IERC20(_address).balanceOf(address(this))
        );
    }

    function withdrawStuckCIC() external onlyOwner {
        require(address(this).balance > 0, "Can't withdraw negative or zero");
        payable(owner()).transfer(address(this).balance);
    }
}