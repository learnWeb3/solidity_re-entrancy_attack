pragma solidity >=0.8.0;

contract Owner {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier isOwner() {
        require(msg.sender == owner, "you are not the owner");
    }
}
