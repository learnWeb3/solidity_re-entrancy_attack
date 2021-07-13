# Re-entrancy vulnerability

## Description:

These files illustrate a basic re-entrancy attack on a vulnarable smart contract

## Quick start

1 - Deploy Victim contract
2 - Deploy Attacker contract providing Victim's address as parameter
3 - Funds the Attacker smar contract calling fundAttacker() function
4 - Deposit funds on Victim contract from Attacker contract to get yourself a balance using  depositToVictim(uint256 _value)
5 - Check your balances using attackerBalance() and attackerBalanceOnVictim()
6 - Lauch the initial contract call using attack(), this function will perform a call requesting Victim's contract to send you your balance on Victim's contract which will invoke the fallback function calling recursively the Victim's withdraw() function

## Tooling 

- solidity >= 0.8.0;
- Remix (deploy debug and run your smart contracts in a VM or using a web3Provider);
