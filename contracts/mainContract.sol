// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract campaignFactory{
    Campaign[] public deployedCampaigns;

    function createCampaign(uint minimum) public  {
        Campaign newCampaign = new Campaign(minimum, msg.sender);
        deployedCampaigns.push(newCampaign);
    }

    function getDeployedCampaigns() public view returns (address[] memory) {
        address[] memory addresses = new address[](deployedCampaigns.length);

        for (uint i = 0; i < deployedCampaigns.length; i++) {
            addresses[i] = address(deployedCampaigns[i]);
        }

        return addresses;
    }
}

contract Campaign{

    struct Request{
        string description;
        uint value;
        address payable  recipient;
        bool complete;
        // uint approvalCount;
        // mapping (address => bool)  approvals;
    }

//create instance of Request struct for use in contract
    Request[] public requsts;

    address public manager;
    uint public minimumContribution;

    mapping (address => bool) public approvers;

//modifier to check the manager address
    modifier restricted(){
        require(msg.sender == manager);
        _;
    }

//set address of manager and mincontribution value to be set is passed on deploy time
    constructor (uint minimum, address campaignCreator)  {
        minimumContribution = minimum;
        manager = campaignCreator;
    }

//when someone wants to send money to our contract
    function contribute() public payable {
        require(msg.value >= minimumContribution);

        approvers[msg.sender] = true;
    }

// create request for donation, checks its only by manager, and add it to reuests array
    function createRequest(string memory description, uint value, address payable  recipient) public restricted {
        Request memory newRequest = Request({
            description: description,
            value: value,
            recipient: recipient,
            complete: false
            //approvalCount: 0
        });

        requsts.push(newRequest);
        //commit
    }

    function finalizeRequest(uint index) public payable  restricted{
        Request storage request = requsts[index];

        require(!request.complete);
        request.recipient.transfer(request.value);
        request.complete = true;
    }
}
