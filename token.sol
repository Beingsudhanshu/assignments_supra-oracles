pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TokenSwap {
    address public owner;
    IERC20 public tokenA;
    IERC20 public tokenB;
    uint public rate;

    event Swapped(address indexed account, uint amountA, uint amountB);

    constructor(IERC20 _tokenA, IERC20 _tokenB, uint _rate) {
        owner = msg.sender;
        tokenA = _tokenA;
        tokenB = _tokenB;
        rate = _rate;
    }

    function swap(uint amount) public {
        uint amountB = amount * rate;
        require(amountB / rate == amount);
        require(tokenA.balanceOf(msg.sender) >= amount, "Insufficient balance of Token A");
        require(tokenB.balanceOf(address(this)) >= amountB, "Insufficient balance of Token B");

        tokenA.transferFrom(msg.sender, address(this), amount);
        tokenB.transfer(msg.sender, amountB);

        emit Swapped(msg.sender, amount, amountB);
    }
}