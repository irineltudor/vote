//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.5.0 < 0.9.0;

contract ElectionFinal{
    struct Candidate{
        string name;
        string about;
        uint numVotes;
    }

    struct Voter{
        uint whom;
        bool voted;
        bool eligible;
    }

    Candidate[] _candidates;
    mapping(address => Voter) _eligibleVoters;

    string _electionName;
    string _country;
    uint _startDate;
    uint _duration;
  
    uint _totalVotes;


    constructor(string memory electionName_,string memory country_,string[] memory candidates_, string[] memory candidatesAbout_, address[] memory eligibleAddress_, uint startDate_,uint duration_){
        _electionName = electionName_;
        _country = country_;
        _startDate = startDate_;
        _duration = duration_;
        _totalVotes = 0;
        
        for(uint i=0;i < candidates_.length;i++)
        {   
            _candidates.push(Candidate(candidates_[i],candidatesAbout_[i],0));
        }

        
        for(uint i=0;i < eligibleAddress_.length;i++)
        {   
            address eligibleAddress = eligibleAddress_[i];
            _eligibleVoters[eligibleAddress]=Voter(0,false,true);
        }
    }

    function hasStarted() public view returns (bool){
        uint today = block.timestamp;
        return (today >= _startDate);
    }

    function hasFinished() public view returns (bool){
        uint today = block.timestamp;
        uint finishElectionTS = _startDate + _duration;
        return today > finishElectionTS;
        
    }
    
    function isRunning() public view returns(bool){
            return hasStarted()&&!hasFinished();
    }


    function getElectionInfo() public view returns(string memory,string memory,uint, uint){
            return(_electionName,_country,_startDate,_duration);
    }


    function getNumOfCandidates() public view returns(uint){
        return _candidates.length;
    }

    function getTotalVotes() public view returns(uint){
        return _totalVotes;
    }

    function isEligible()public view returns(bool){
        return (_eligibleVoters[msg.sender].eligible == true);

    }

    function alreadyVoted()public view returns(bool){
        return(_eligibleVoters[msg.sender].voted);
    }

    function vote(uint voterChoice_) public{
        require(voterChoice_ < _candidates.length ,"Voter's choice does not exist");
        require(isEligible(), "Person is not eligible to vote at this Election");
        require(!alreadyVoted(), "Person already voted");
        require(isRunning(),"Election is not running");
        

        _eligibleVoters[msg.sender].whom = voterChoice_;
        _eligibleVoters[msg.sender].voted = true;
        
        _candidates[voterChoice_].numVotes++;
        _totalVotes++;

    }

    function getCandidateInfo(uint index)public view returns (string memory,string memory){
        return (_candidates[index].name,_candidates[index].about);
    }

    function getCandidateResults(uint index)public view returns (string memory,string memory,uint){
        require(hasFinished(),"Election is not finished");
        return (_candidates[index].name,_candidates[index].about,_candidates[index].numVotes);
    }


    function whom() public view returns(uint){
            require(isEligible(), "Person is not eligible");
            require(alreadyVoted(), "Person did not vote");
            require(hasFinished(),"Election is not finished");
            return _eligibleVoters[msg.sender].whom;
    }
}