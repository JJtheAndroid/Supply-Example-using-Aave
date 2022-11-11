// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import {IPool} from "@aave/core-v3/contracts/interfaces/IPool.sol";
import {IPoolAddressesProvider} from "@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";
import {IERC20} from "@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";


/*In this example, the user directly provides Aave test LINK to this contract. Please
note that Aave uses its own testnet addresses to use on their own protocol. Please use testnet 
mode on Aave and use the faucet before sending tokens  
*/

//This contract is made for the ETH goerli network

contract AaveforLINK {
   
    //this address provides the principal and the profit for this contract
    address public aLink = 0x6A639d29454287B3cBB632Aa9f93bfB89E3fd18f;

    //this line fetches the address for the pool
    IPoolAddressesProvider public immutable ADDRESSES_PROVIDER;
    IPool public immutable POOL;


    address private immutable linkAddress =
        0x07C725d58437504CA5f814AE406e70E21C5e8e9e;
    IERC20 private link;

    constructor(address _addressProvider) payable {
        ADDRESSES_PROVIDER = IPoolAddressesProvider(_addressProvider);
        POOL = IPool(ADDRESSES_PROVIDER.getPool());
       
        link = IERC20(linkAddress);
        approveLINK(); 
    }

    //this function supplies the liquidity on Aave. In this examples exchanging LINK for aLink
    function supplyLiquidity() external {
        address asset = linkAddress;
        uint256 amount = link.balanceOf(address(this));
        address onBehalfOf = address(this);
        uint16 referralCode = 0;

        POOL.supply(asset, amount, onBehalfOf, referralCode);
    }

    //this function withdraws the liquidity 
    function withdrawlLiquidity()
        external
        returns (uint256)
    {   
        address asset = linkAddress; //this must the link address not the aLink address
        uint256 amount = IERC20(aLink).balanceOf(address(this)); //the entire balance + profit
        address to = address(this);

        return POOL.withdraw(asset, amount, to);
    }

   //this is an internal function that approves the POOL to spend your LINK tokens 
   function approveLINK()
        internal
        returns (bool)
    {
        return link.approve(address(POOL), 115792089237316195423570985008687907853269984665640564039457584007913129);
    }

    //this function checks the allowance
    function allowanceLINK(address _poolContractAddress)
        external
        view
        returns (uint256)
    {
        return link.allowance(address(this), _poolContractAddress);
    }

    //this function returns the balance of ERC20 token
    function getBalance(address _tokenAddress) external view returns (uint256) {
        return IERC20(_tokenAddress).balanceOf(address(this));
    }

    //this line returns the balance and the profit of the contract. Profit updates almost every min
    function getBalanceandProfitLINK () external view returns (uint256){
        return IERC20(aLink).balanceOf(address(this));
    }

    receive() external payable {}
}
