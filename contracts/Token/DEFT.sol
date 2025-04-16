// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/*
    __________________________________
    ___  __ \__  ____/__  ____/__  __/
    __  / / /_  __/  __  /_   __  /   
    _  /_/ /_  /___  _  __/   _  /    
    /_____/ /_____/  /_/      /_/     

*/

/// @title DEFT token contract

contract DEFT is ERC20 {

    constructor(string memory name_, string memory symbol_) ERC20(name_, symbol_) {}
}