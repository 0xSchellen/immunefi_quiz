// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

//import "openzeppelin-contracts/token/ERC20/ERC20.sol";
import "openzeppelin-contracts/token/ERC20/utils/SafeERC20.sol";
import "openzeppelin-contracts/security/ReentrancyGuard.sol";

contract SafeContract is ReentrancyGuard{
    using SafeERC20 for IERC20;

    //address public immutable vulnTokenDeployAddress;
    IERC20 internal immutable vulnTokenAddress;

    // This contract is holding 20k VulnTokens
    //IERC20 internal vulnTokenAddress = IERC20(address(vulnTokenDeployAddress));

    constructor(address _vulnTokenDeployAddress) {
        vulnTokenAddress = IERC20(address(_vulnTokenDeployAddress));
    }

    function TransferAmount (address _erc20Address) external nonReentrant {
        uint _userBalance = IERC20(_erc20Address).balanceOf(msg.sender);

        vulnTokenAddress.safeTransfer(msg.sender, _userBalance);
    }

}
