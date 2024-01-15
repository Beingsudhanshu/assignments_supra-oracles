pragma solidity ^0.8.0;

contract decentralizedVoting {

    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }

    struct Voter {
        bool isRegistered;
        bool hasVoted;
        uint votedToCandidateId;
    }

    address public owner;

    mapping(address => Voter) public voters;
    mapping(uint => Candidate) public candidates;

    uint public candidatesCount;
    bool public votingOpen = true;

    event Registered(address voter);
    event Voted(address voter, uint256 candidateId);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    modifier OnlyVotingOpen() {
        require(votingOpen, "Voting is closed");
        _;
    }

    function addCandidate(string memory _name) public onlyOwner {
        candidatesCount++;
        candidates[candidatesCount] = Candidate(candidatesCount, _name, 0);
    }

    function register() public OnlyVotingOpen {
        require(!voters[msg.sender].isRegistered, "Voter is already registered");
        voters[msg.sender].isRegistered = true;
        emit Registered(msg.sender);
    }

    function vote(uint _candidateId) public OnlyVotingOpen {
        require(voters[msg.sender].isRegistered, "Voter is not registered");
        require(!voters[msg.sender].hasVoted, "Voter has already voted");
        require(_candidateId > 0 && _candidateId <= candidatesCount);

        voters[msg.sender].hasVoted = true;
        voters[msg.sender].votedToCandidateId = _candidateId;
        candidates[_candidateId].voteCount++;

        emit Voted(msg.sender, _candidateId);
    }

    function closeRegistration() public onlyOwner {
        votingOpen = false;
    }
}