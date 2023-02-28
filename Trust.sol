// SPDX-License-Identifier: GPL-3.0
//https://www.youtube.com/watch?v=MTC8BHrmrJA video I watched to do this project
//storage - variable is a state variable (store on blockchain)
//memory - variable is in memory and it exists while a function is being called
//calldata - special data location that contains function arguments

pragma solidity >=0.8.2 <0.9.0;

contract Trust {

    //address public kid;
    //uint public maturity;
    // constructor(address kid, uint timeToMaturity) payable {
    //     maturity = block.timestamp + timeToMaturity;
    //     kid = kid;

    // }

    struct Kid {

        uint amount;
        uint maturity;
    } 
    address public admin;
    mapping(address => Kid) public kids;

    constructor() {
        admin = msg.sender;
    }

    function getKid(address kid) public view returns (Kid memory) {
        Kid memory kido = kids[kid];
        return kido;
    }

    function addKid(address kid, uint timeToMaturity) external payable {
        require(msg.sender == admin, 'only admin');
        require(kids[msg.sender].amount == 0, 'kid already exist');

        kids[kid] = Kid(msg.value , block.timestamp + timeToMaturity);
    }

    //note: external vs public (https://ethereum.stackexchange.com/questions/19380/external-vs-public-best-practices)
    //Calling each function, we can see that the public function uses 496 gas, while the external function uses only 261.
    //The difference is because in public functions, Solidity immediately copies array arguments to memory, while external functions can read directly from calldata. Memory allocation is expensive, whereas reading from calldata is cheap.

    function withdraw() external {
        Kid storage kid = kids[msg.sender];
        require(kid.maturity <= block.timestamp, "too earyly");
        require(kid.amount > 0, "only kid can withdraw"); // even if the address is not in the map, in solidity, they will return you default value "0"
        payable(msg.sender).transfer(kid.amount);
        //two types of address: address and address payable. You can only pay ether to address payable
        //really good explaination of address concept : https://jeancvllr.medium.com/solidity-tutorial-all-about-addresses-ffcdf7efc4e7 
    }






}