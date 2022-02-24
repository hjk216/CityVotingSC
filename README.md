# City Voting Smart Contract

This is an experimental smart contract for city votes written in Solidity and tests in Javascript. The administrator of the contract may add and remove voters to the voting roll. They can create a ballot, add elections, add issues, then open and close the ballot. Voters can vote on elections and issues if the ballot is created and open. 

This contract has a downside since it is basically controlled by the administrator. However, it provides benefits such as, no one entity is controlling the network itself, prevents voters from voting twice, verifiable votes, and vote confirmation. It brings transparency to the system without exposing personal information as voters can vote through their public/private key pair. 

### Technology Used
This application was built using Truffle, Ganache, Solidity, and Javascript.

### Installation
1. Download Directory
2. Add Truffle project to Ganache workspace
3. Run "truffle migrate"
4. Run tests with "truffle test"
5. Use console with "truffle console"

### Next Steps
- Make more gas efficient
- Write more thorough tests
- Adjust, or create new project, without central administrator
