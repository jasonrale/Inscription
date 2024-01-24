// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Template {
    string public name; 

    string public symbol;   

    uint8 public decimals = 18;

    uint256 public totalSupply;

    uint256 public perMint;

    address public inscriber;

    mapping(address account => uint256) private _balances;
    mapping(address account => mapping(address spender => uint256)) private _allowances;

    error ERC20InsufficientBalance(address sender, uint256 balance, uint256 needed);

    error ERC20InvalidSender(address sender);

    error ERC20InvalidReceiver(address receiver);

    error ERC20InsufficientAllowance(address spender, uint256 allowance, uint256 needed);

    error ERC20InvalidApprover(address approver);

    error ERC20InvalidSpender(address spender);

    error NoTokensReceived(address recipient);

    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    function transfer(address to, uint256 value) public returns (bool) {
        address owner = _msgSender();
        _transfer(owner, to, value);
        return true;
    }

    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowances[owner][spender];
    }

    function init(string calldata _name, string calldata _symbol, uint256 _perMint) external  {
        name = _name;
        symbol = _symbol;
        perMint = _perMint;
        inscriber = _msgSender();
    }

    function mint(address to) external {
        require(msg.sender == inscriber, "Only Inscriber");
        _mint(to, perMint);
    }

    function approve(address spender, uint256 value) public returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, value);
        return true;
    }

    function transferFrom(address from, address to, uint256 value) public returns (bool) {
        address spender = _msgSender();
        _spendAllowance(from, spender, value);
        _transfer(from, to, value);
        return true;
    }

    function _msgSender() internal view returns (address) {
        return msg.sender;
    }

    function isContract(address account) internal view returns (bool) {
      return account.code.length > 0;
    }

    function _transfer(address from, address to, uint256 value) internal {
        if (from == address(0)) {
            revert ERC20InvalidSender(address(0));
        }
        if (to == address(0)) {
            revert ERC20InvalidReceiver(address(0));
        }
        _update(from, to, value);
    }

    function _update(address from, address to, uint256 value) internal {
        if (from == address(0)) {
            totalSupply += value;
        } else {
            uint256 fromBalance = _balances[from];
            if (fromBalance < value) {
                revert ERC20InsufficientBalance(from, fromBalance, value);
            }
            _balances[from] = fromBalance - value;
        }

        if (to == address(0)) {
                totalSupply -= value;
        } else {
                _balances[to] += value;
        }
    }

    function _mint(address account, uint256 value) internal {
        if (account == address(0)) {
            revert ERC20InvalidReceiver(address(0));
        }
        _update(address(0), account, value);
    }

    function _approve(address owner, address spender, uint256 value) internal {
        if (owner == address(0)) {
            revert ERC20InvalidApprover(address(0));
        }
        if (spender == address(0)) {
            revert ERC20InvalidSpender(address(0));
        }
        _allowances[owner][spender] = value;
    }

    function _spendAllowance(address owner, address spender, uint256 value) internal {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance != type(uint256).max) {
            if (currentAllowance < value) {
                revert ERC20InsufficientAllowance(spender, currentAllowance, value);
            }
            _approve(owner, spender, currentAllowance - value);
        }
    }
}