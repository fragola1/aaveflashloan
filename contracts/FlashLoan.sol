//@dev/Developer = fragola1
//@.NET/Network = Kovan Test Network

pragma solidity ^0.6.6;
import "./FlashLoanReceiverBase.sol";
import "./ILendingPoolAddressesProvider.sol";
import "./ILendingPool.sol";

contract FlashloanV1 is FlashLoanReceiverBaseV1 {
    
    string _Real_Owner = "Pavan Ananth Sharma" ;
    
    function Owner_Of_This_Contract() public view returns(string memory){
        return _Real_Owner;
    }

    constructor(address _addressProvider) FlashLoanReceiverBaseV1(_addressProvider) public{}

 /**
        Flash loan 1000000000000000000 wei (1 ether) worth of `_asset`
     */
 function flashloan(address _asset) public onlyOwner {
        bytes memory data = "";
        uint amount = 1000000 ether; //questo è l'importo del prestito che verrà visualizzato o convertito in DAI, il che significa che se inserisci 100 qui prenderai un prestito di 100 DAI e così via
        //in pratica possiamo dire che questo importo prelevato viene convertito in wei che è un piccolo decimale di ETH e quindi viene inserito nel pool di memoria per l'estrazione del DAI

        ILendingPoolV1 lendingPool = ILendingPoolV1(addressesProvider.getLendingPool());
        lendingPool.flashLoan(address(this), _asset, amount, data);
    }

    /**
 Questa funzione viene richiamata dopo che il contratto ha ricevuto l'importo in prestito flash
     */
    function executeOperation(
        address _reserve,
        uint256 _amount,
        uint256 _fee,
        bytes calldata _params
    )
        external
        override
    {
        require(_amount <= getBalanceInternal(address(this), _reserve), "Invalid balance, was the flashLoan successful?");
       //
        // Your logic goes here.
        // !! Ensure that *this contract* has enough of `_reserve` funds to payback the `_fee` !!
        //

        uint totalDebt = _amount.add(_fee);
        transferFundsBackToPoolInternal(_reserve, totalDebt);
    }

}
