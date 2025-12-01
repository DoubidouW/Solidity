// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "./IERC20.sol";

contract MyToken is IERC20 {
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 private _totalSupply;
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) public allowance;
    address public owner;
    
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Mint(address indexed to, uint256 value);
    event Burn(address indexed from, uint256 value);
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Seul le proprietaire peut executer cette fonction");
        _;
    }
    
    constructor() {
        name = "MyToken";
        symbol = "MTK";
        decimals = 18;
        owner = msg.sender;
        uint256 initialSupply = 1_000_000 * 10**uint256(decimals);
        _totalSupply = initialSupply;
        _balances[msg.sender] = initialSupply;
        emit Transfer(address(0), msg.sender, initialSupply);
    }
    
    function totalSupply() external view override returns (uint256) {
        return _totalSupply;
    }
    
    function balanceOf(address account) external view override returns (uint256) {
        return _balances[account];
    }
    
    function transfer(address recipient, uint256 amount) external override returns (bool) {
        require(msg.sender != address(0), "Transfer depuis l'adresse zero interdite");
        require(recipient != address(0), "Transfer vers l'adresse zero interdite");
        require(_balances[msg.sender] >= amount, "Solde insuffisant");
        _balances[msg.sender] -= amount;
        _balances[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }
    
    function approve(address spender, uint256 amount) external override returns (bool) {
        require(spender != address(0), "Approbation vers l'adresse zero interdite");
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }
    
    function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
        require(sender != address(0), "Transfer depuis l'adresse zero interdite");
        require(recipient != address(0), "Transfer vers l'adresse zero interdite");
        require(_balances[sender] >= amount, "Solde insuffisant");
        require(allowance[sender][msg.sender] >= amount, "Allowance insuffisante");
        _balances[sender] -= amount;
        _balances[recipient] += amount;
        allowance[sender][msg.sender] -= amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }
    
    function mint(uint256 amount) external onlyOwner {
        require(amount > 0, "Le montant doit etre superieur a zero");
        _totalSupply += amount;
        _balances[owner] += amount;
        emit Mint(owner, amount);
        emit Transfer(address(0), owner, amount);
    }
    
    function burn(uint256 amount) external {
        require(amount > 0, "Le montant doit etre superieur a zero");
        require(_balances[msg.sender] >= amount, "Solde insuffisant pour bruler");
        _totalSupply -= amount;
        _balances[msg.sender] -= amount;
        emit Burn(msg.sender, amount);
        emit Transfer(msg.sender, address(0), amount);
    }
    
    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "Nouveau proprietaire invalide");
        owner = newOwner;
    }
}
