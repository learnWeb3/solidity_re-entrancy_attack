pragma solidity >=0.8.0;

contract Victim {
    mapping(address => uint256) public userBalances;

    // Vulnerable function to re-entrancy attack due to the use of call function (no limitation on gas usage) and mismanaged state update
    function withdraw() external payable {
        require(userBalances[msg.sender] > 0, "user does not have funds");
        (bool success, ) = msg.sender.call{value: userBalances[msg.sender]}("");
        require(success, "transfer failed");
        userBalances[msg.sender] = 0;
    }

    // perform a deposit on the contract, updating user balance on contract
    function deposit() external payable {
        userBalances[msg.sender] += msg.value;
    }
}
