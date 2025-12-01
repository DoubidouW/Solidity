// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

//ici on importe le fichier ou sont les interfaces
import "./IERC20.sol";


contract MyToken is IERC20 {
    string public name; // ici on va déclaarer les diffentes variables
    string public symbol;
    uint8 public decimals;
    uint256 public _totalSupply;
    mapping(address => uint256) public _balances;
    mapping(address => mapping(address => uint256)) public allowance;
    address public owner;
    
    // ic on déclare les évenement lié à ERC20 (l'envoi, la reception etc)
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

// ici on vérifie que seul le propriétaire execute cette fonction, et on la met dans un message    
    modifier onlyOwner() {
        require(msg.sender == owner, "Seul le proprietaire peut executer cette fonction");
        _;
    }

//ici le constructeur execute 1 fois les infos, dans note    
    constructor() {
        name = "MyToken";
        symbol = "MTK";
        decimals = 18;
        owner = msg.sender;
        uint256 initialSupply = 1_000_000 * 10**uint256(decimals); //il faut convertir cazr la blockchain gère des décimal, donc il faut mulitplier
        _totalSupply = initialSupply; //ici on defini le total de token
        _balances[msg.sender] = initialSupply; //ici on donne les token au propriétaire
        emit Transfer(address(0), msg.sender, initialSupply); //ici on affiche le supply inital
    }
//ici on déclare la fdonction pour retourner la quantité de token qui existe dans le contrat     
    function totalSupply() external view override returns (uint256) {
        return _totalSupply;
    }

//ici on cherhche le solde de l'utilisateur avec balances account    
    function balanceOf(address account) external view override returns (uint256) {
        return _balances[account];
    }
    
//cette fonction envoi les token directement depuis son compte
    function transfer(address recipient, uint256 amount) external override returns (bool) {
        require(msg.sender != address(0), "Transfer depuis l'adresse zero interdite");
        require(recipient != address(0), "Transfer vers l'adresse zero interdite");
        require(_balances[msg.sender] >= amount, "Solde insuffisant");
        _balances[msg.sender] -= amount;
        _balances[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }


//permet d'autoriser une autre adresse pour dépenser les toekns
    function approve(address spender, uint256 amount) external override returns (bool) {
        require(spender != address(0), "Approbation vers l'adresse zero interdite");
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }
// du coup ici on fait l'action de dépense suite à l'autorisation    
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
    

}
