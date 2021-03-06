pragma solidity ^0.4.11;


import "zeppelin-solidity/contracts/token/StandardToken.sol";
import "zeppelin-solidity/contracts/ownership/Ownable.sol";
import "zeppelin-solidity/contracts/math/SafeMath.sol";


contract BankexToken is StandardToken, Ownable {
    using SafeMath for uint256;

    string public constant name = "BANKEX Token";

    string public constant symbol = "BKX";

    uint8 public constant decimals = 9;

    uint256 private constant multiplier = 10 ** uint256(decimals);

    uint256 public constant totalSupply = 222387500 * multiplier; //TODO: finalize

    uint256 public constant reservedForPbkx = 3000000 * multiplier; //TODO: finalize

    address public pbkxToken;

    address public bankexTokenWallet;

    function BankexToken(address _bankexTokenWallet, address _pbkxToken, uint256 _tokensForSale) {
        require(_bankexTokenWallet != address(0));
        require(_pbkxToken != address(0));
        require(_tokensForSale > 0);
        bankexTokenWallet = _bankexTokenWallet;
        pbkxToken = _pbkxToken;
        balances[pbkxToken] = reservedForPbkx;
        balances[msg.sender] = _tokensForSale;
        balances[_bankexTokenWallet] = totalSupply.sub(reservedForPbkx).sub(_tokensForSale);
    }

    bool public frozen = true;

    event Unfrozen();

    function unfreeze() public returns (bool) {
        require(msg.sender == bankexTokenWallet);
        require(frozen);
        frozen = false;
        Unfrozen();
        return true;
    }

    modifier notFrozen() {
        require(!frozen);
        _;
    }

    function transfer(address _to, uint256 _value) public returns (bool) {
        require(!frozen || msg.sender == owner || msg.sender == bankexTokenWallet);
        return super.transfer(_to, _value);
    }

    function transferFrom(address _from, address _to, uint256 _value) public notFrozen returns (bool) {
        return super.transferFrom(_from, _to, _value);
    }

    function approve(address _spender, uint256 _value) public notFrozen returns (bool) {
        return super.approve(_spender, _value);
    }

    function increaseApproval(address _spender, uint _addedValue) public notFrozen returns (bool success) {
        return super.increaseApproval(_spender, _addedValue);
    }

    function decreaseApproval(address _spender, uint _subtractedValue) public notFrozen returns (bool success) {
        return super.decreaseApproval(_spender, _subtractedValue);
    }

    function transferFromOwner(address _to, uint256 _value) public returns (bool) {
        require(msg.sender == pbkxToken);
        return super.transfer(_to, _value);
    }
}
