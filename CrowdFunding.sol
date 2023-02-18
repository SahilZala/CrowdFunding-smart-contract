// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 < 0.9.0;

contract CrowdFunding{
    address public _manager;

    struct Campaign{
        address _address;
        int _id;
        string _name;
        string _campaignTitle;
        string _label;
        string _story;
        int _goal;
        string _endDate;
        string _imageUrl;
        bool _active;
    }    

    struct Fund{
        int _id;
        address _address;
        uint _fund;
        string _date;
    }

    address[] public _list;
    mapping(address=>Campaign[]) public _data;
    mapping(int=>Fund[]) public _funding; 


    constructor(){
        _manager = msg.sender;
    }

    function getAddressList() public view returns(address[] memory){
        return _list;
    }

    function createCampaign(int id,
                string memory name,
                string memory campaignTitle,
                string memory label,
                string memory story,
                int goal,
                string memory endDate,
                string memory imageUrl) public{
        
        
        Campaign memory c;
        c._address = msg.sender;
        c._id = id;
        c._name = name;
        c._campaignTitle = campaignTitle;
        c._label = label;
        c._story = story;
        c._goal = goal;
        c._endDate = endDate;
        c._imageUrl = imageUrl;
        
        if(_data[c._address].length == 0)
        {
            _list.push(c._address);
        }
        _data[c._address].push(c); 

    }

    function getCampaignList(address _address) view public returns(Campaign[] memory){
        return _data[address(_address)];
    }  

    function donate(int fid,uint ammount,int cid,address caddress,string memory date) payable public{
        if(caddress == address(msg.sender))
            revert("campaign owner not allowed to donate his own campaign.");
        address payable d = payable(caddress); 
        d.transfer(ammount);
        Fund memory f;
        f._id = fid;
        f._address = msg.sender;
        f._date = date;
        f._fund = ammount;
        _funding[cid].push(f);   
    }

    function getFunding(int cid) view public returns(Fund[] memory){
        return _funding[cid];
    }

    function getBalance(int cid) view public returns(uint,uint){
        uint sum = 0;
        uint len = _funding[cid].length;
        for(uint i=0;i<len;i++){
            sum += _funding[cid][i]._fund;
        }
        return(sum,len);
    } 
}



