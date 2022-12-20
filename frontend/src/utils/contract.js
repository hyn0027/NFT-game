import Web3 from 'web3'
// var Contract = Web3.eth.Contract;
// Contract.setProvider('ws://localhost:8546');
const address = "0x5FbDB2315678afecb367f032d93F642f64180aa3";
import jsonInterface from './ABI.json' assert { type: 'JSON' };
const web3 = new Web3()
var contract = new web3.eth.Contract(jsonInterface, address);
contract.setProvider('ws://localhost:8545');
export default {contract}