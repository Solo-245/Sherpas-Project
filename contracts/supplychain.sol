// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title SupplyChain
 * @dev A simple supply chain management contract that allows the owner to add, update, and manage products.
 */
contract SupplyChain {
    // Enum to represent the product status
    enum Status { Created, Shipped, Delivered, Canceled }

    // Struct to represent products in the supply chain
    struct Product {
        string name;        // Name of the product
        uint256 price;      // Price of the product (normalized to 18 decimals)
        uint256 quantity;   // Available quantity with the manufacturer
        Status status;      // Current status of the product
        bool exists;        // Flag to check if the product exists
    }

    // Mapping of product ID to Product struct
    mapping(uint256 => Product) public products;

    // Events for logging actions
    event ProductAdded(
        uint256 indexed productId,
        string name,
        uint256 price,
        uint256 quantity,
        address indexed addedBy
    );

    event ProductUpdated(
        uint256 indexed productId,
        uint256 price,
        uint256 quantity,
        Status status,
        address indexed updatedBy
    );

    event ProductStatusUpdated(
        uint256 indexed productId,
        Status status,
        address indexed updatedBy
    );

    event FundsWithdrawn(address indexed owner, uint256 amount);

    address public owner;
    bool private locked; // Reentrancy guard

    /**
     * @dev Constructor to initialize ownership.
     */
    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    modifier nonReentrant() {
        require(!locked, "Reentrant call");
        locked = true;
        _;
        locked = false;
    }

    /**
     * @dev Adds a new product to the supply chain.
     * @param productId Unique identifier for the product.
     * @param name Name of the product.
     * @param quantity Initial quantity of the product.
     */
    function addProduct(
        uint256 productId,
        string memory name,
        uint256 quantity
    ) external onlyOwner {
        require(!products[productId].exists, "Product already exists");
        require(bytes(name).length > 0, "Product name cannot be empty");

        uint256 price = getLatestPrice(); // Simulate price fetching
        products[productId] = Product(name, price, quantity, Status.Created, true);

        emit ProductAdded(productId, name, price, quantity, msg.sender);
    }

    /**
     * @dev Updates the price and quantity of an existing product.
     * @param productId Identifier of the product to update.
     * @param quantity New quantity of the product.
     */
    function updateProduct(uint256 productId, uint256 quantity) external onlyOwner {
        require(products[productId].exists, "Product does not exist");

        uint256 price = getLatestPrice(); // Simulate price fetching
        products[productId].price = price;
        products[productId].quantity = quantity;

        emit ProductUpdated(productId, price, quantity, products[productId].status, msg.sender);
    }

    /**
     * @dev Updates the status of a product.
     * @param productId Identifier of the product.
     * @param status New status of the product.
     */
    function updateProductStatus(uint256 productId, Status status) external onlyOwner {
        require(products[productId].exists, "Product does not exist");

        products[productId].status = status;

        emit ProductStatusUpdated(productId, status, msg.sender);
    }

    /**
     * @dev Simulates fetching the latest price (replace with actual implementation).
     * @return Normalized latest price.
     */
    function getLatestPrice() internal view returns (uint256) {
        // Simulated price fetching logic
        return 100 * 10 ** 18; // Example price, replace with actual logic
    }

    /**
     * @dev Withdraws all Ether from the contract to the owner's address.
     */
    function withdrawFunds() external onlyOwner nonReentrant {
        uint256 balance = address(this).balance;
        require(balance > 0, "No funds to withdraw");

        (bool success, ) = payable(owner).call{value: balance}("");
        require(success, "Withdrawal failed");

        emit FundsWithdrawn(owner, balance);
    }

    /**
     * @dev Fallback function to accept Ether.
     */
    receive() external payable {}

    /**
     * @dev Fallback function to handle unexpected calls.
 */
    fallback() external payable {}
}