// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "@openzeppelin/contracts/governance/Governor.sol";
import
    "@openzeppelin/contracts/governance/compatibility/GovernorCompatibilityBravo.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorVotes.sol";
import
    "@openzeppelin/contracts/governance/extensions/GovernorVotesQuorumFraction.sol";
import
    "@openzeppelin/contracts/governance/extensions/GovernorTimelockControl.sol";

/*
    __________________________________
    ___  __ \__  ____/__  ____/__  __/
    __  / / /_  __/  __  /_   __  /   
    _  /_/ /_  /___  _  __/   _  /    
    /_____/ /_____/  /_/      /_/     

*/

/// @title Deft Governor
contract DeftGovernor is
    GovernorCompatibilityBravo,
    GovernorVotes,
    GovernorVotesQuorumFraction,
    GovernorTimelockControl
{

    error INVALID_SIGNATURES_LENGTH();

    /// @notice Initializes the contract.
    /// @param _owner The owner of this contract. msg.sender will be used if this value is zero.
    /// @param _token The Deft token.
    /// @param _timelock The timelock contract address.
    constructor(
        address _owner,
        IVotes _token,
        TimelockController _timelock
    ) 
        Governor("DeftGovernor")
        GovernorVotes(_token)
        GovernorVotesQuorumFraction(5)
        GovernorTimelockControl(_timelock)
    {}

    /// @dev See {IGovernor-propose}
    function propose(
        address[] memory _targets,
        uint256[] memory _values,
        bytes[] memory _calldatas,
        string memory _description
    )
        public
        override(IGovernor, Governor, GovernorCompatibilityBravo)
        returns (uint256)
    {
        return super.propose(_targets, _values, _calldatas, _description);
    }

    /// @notice An overwrite of GovernorCompatibilityBravo's propose() as that one does
    /// not check that the length of signatures equal the calldata.
    /// See {GovernorCompatibilityBravo-propose}
    function propose(
        address[] memory _targets,
        uint256[] memory _values,
        string[] memory _signatures,
        bytes[] memory _calldatas,
        string memory _description
    )
        public
        virtual
        override(GovernorCompatibilityBravo)
        returns (uint256)
    {
        if (_signatures.length != _calldatas.length) revert INVALID_SIGNATURES_LENGTH();

        return GovernorCompatibilityBravo.propose(
            _targets, _values, _signatures, _calldatas, _description
        );
    }

    function cancel(
        address[] memory targets,
        uint256[] memory values,
        bytes[] memory calldatas,
        bytes32 descriptionHash
    ) 
        public 
        virtual 
        override(IGovernor, Governor, GovernorCompatibilityBravo)
        returns (uint256) 
    {
        return super.cancel(targets, values, calldatas, descriptionHash);
    }

    /// @dev See {Governor-supportsInterface}
    function supportsInterface(bytes4 _interfaceId)
        public
        view
        override(Governor, GovernorTimelockControl, IERC165)
        returns (bool)
    {
        return super.supportsInterface(_interfaceId);
    }

    /// @dev See {Governor-state}
    function state(uint256 _proposalId)
        public
        view
        override(IGovernor, Governor, GovernorTimelockControl)
        returns (ProposalState)
    {
        return super.state(_proposalId);
    }

    /// @notice How long after a proposal is created should voting power be fixed. A
    /// large voting delay gives users time to unstake tokens if necessary.
    /// @return The duration of the voting delay.
    function votingDelay() public pure override returns (uint256) {
        return 7200; // 1 day
    }

    /// @notice How long does a proposal remain open to votes.
    /// @return The duration of the voting period.
    function votingPeriod() public pure override returns (uint256) {
        return 50_400; // 1 week
    }

    /// @notice The number of votes required in order for a voter to become a proposer.
    /// @return The number of votes required.
    function proposalThreshold() public pure override returns (uint256) {
        return 1_000_000_000 ether / 10_000;
    }

    function _execute(
        uint256 _proposalId,
        address[] memory _targets,
        uint256[] memory _values,
        bytes[] memory _calldatas,
        bytes32 _descriptionHash
    )
        internal
        override(Governor, GovernorTimelockControl)
    {
        super._execute(_proposalId, _targets, _values, _calldatas, _descriptionHash);
    }

    function _cancel(
        address[] memory _targets,
        uint256[] memory _values,
        bytes[] memory _calldatas,
        bytes32 _descriptionHash
    )
        internal
        override(Governor, GovernorTimelockControl)
        returns (uint256)
    {
        return super._cancel(_targets, _values, _calldatas, _descriptionHash);
    }

    function _executor()
        internal
        view
        override(Governor, GovernorTimelockControl)
        returns (address)
    {
        return super._executor();
    }
}