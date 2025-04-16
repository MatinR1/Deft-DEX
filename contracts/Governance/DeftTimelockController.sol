// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "@openzeppelin/contracts/governance/TimelockController.sol";

/*
    __________________________________
    ___  __ \__  ____/__  ____/__  __/
    __  / / /_  __/  __  /_   __  /   
    _  /_/ /_  /___  _  __/   _  /    
    /_____/ /_____/  /_/      /_/     

*/

/// @title Deft Timelock Controller

contract DeftTimelockController is TimelockController {

    /// @notice Initializes the contract.
    /// @param _owner The owner of this contract. msg.sender will be used if this value is zero.
    /// @param _minDelay The minimal delay.

    constructor(address _owner, address[] memory proposers, address[] memory executors, uint256 _minDelay)
        TimelockController(_minDelay, proposers, executors, _owner) {}
        

    /// @dev Gets the minimum delay for an operation to become valid, allows the admin to get around
    /// of the min delay.
    /// @return The minimum delay.
    function getMinDelay() public view override returns (uint256) {
        return hasRole(TIMELOCK_ADMIN_ROLE, msg.sender) ? 0 : super.getMinDelay();
    }
}