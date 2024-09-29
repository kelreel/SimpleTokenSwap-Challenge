// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

// Implement Uniswap swap interface
// Implement library to help with token transfers

// Import the Uniswap V3 interface
import "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// Token transfer helper library
library TransferHelper {
    // Safe approve function to approve token spending
    function safeApprove(address token, address to, uint256 value) internal {
        (bool success, bytes memory data) = token.call(
            abi.encodeWithSelector(IERC20.approve.selector, to, value)
        );
        require(
            success && (data.length == 0 || abi.decode(data, (bool))),
            "TransferHelper: APPROVE_FAILED"
        );
    }

    // Safe transfer function to transfer tokens
    function safeTransfer(address token, address to, uint256 value) internal {
        (bool success, bytes memory data) = token.call(
            abi.encodeWithSelector(IERC20.transfer.selector, to, value)
        );
        require(
            success && (data.length == 0 || abi.decode(data, (bool))),
            "TransferHelper: TRANSFER_FAILED"
        );
    }

    // Safe transferFrom function to pull tokens from a user's wallet
    function safeTransferFrom(
        address token,
        address from,
        address to,
        uint256 value
    ) internal {
        (bool success, bytes memory data) = token.call(
            abi.encodeWithSelector(
                IERC20.transferFrom.selector,
                from,
                to,
                value
            )
        );
        require(
            success && (data.length == 0 || abi.decode(data, (bool))),
            "TransferHelper: TRANSFER_FROM_FAILED"
        );
    }
}

// 0xfc30937f5cDe93Df8d48aCAF7e6f5D8D8A31F636  - scroll sepolia router
// 0x5300000000000000000000000000000000000004 - scroll sepolia weth

contract SimpleTokenSwapper {
    ISwapRouter public immutable swapRouter;
    address public immutable WETH;

    // Define the constructor
    constructor(ISwapRouter _swapRouter, address _weth) {
        swapRouter = _swapRouter;
        WETH = _weth;
    }

    // Swap function that takes input token, output token, input amount, min output amount, and recipient
    function swap(
        address tokenIn, // The input token address (e.g., USDC)
        address tokenOut, // The output token address (e.g., WETH)
        uint256 amountIn, // The input token amount
        uint256 amountOutMinimum, // The minimum acceptable output amount
        address recipient // Address that will receive the output tokens
    ) external returns (uint256 amountOut) {
        // Transfer input tokens from the sender to this contract
        TransferHelper.safeTransferFrom(
            tokenIn,
            msg.sender,
            address(this),
            amountIn
        );

        // Approve the Uniswap router to spend the input tokens
        TransferHelper.safeApprove(tokenIn, address(swapRouter), amountIn);

        // Define the Uniswap V3 swap parameters
        ISwapRouter.ExactInputSingleParams memory params = ISwapRouter
            .ExactInputSingleParams({
                tokenIn: tokenIn, // Input token
                tokenOut: tokenOut, // Output token
                fee: 3000, // Pool fee for Uniswap (0.3%)
                recipient: recipient, // Where to send the output tokens
                deadline: block.timestamp + 15, // Transaction deadline (15 seconds)
                amountIn: amountIn, // Amount of input token
                amountOutMinimum: amountOutMinimum, // Minimum acceptable output amount
                sqrtPriceLimitX96: 0 // No price limit
            });

        // Execute the swap on Uniswap and return the output amount
        amountOut = swapRouter.exactInputSingle(params);
    }
}
