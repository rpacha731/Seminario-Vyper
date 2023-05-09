const Customer = artifacts.require("customer");
const Restaurant = artifacts.require("restaurant");

contract("Customer", async accounts => {
    it("should create a customer, create a menu and attend a customer", async () => {
        let cust = await Customer.deployed();
        let rest = await Restaurant.deployed();

        await cust.saveNewCustomer("Leo", "Mesa 10", 2, 1);

        console.log("Customer created", await cust.getCustomer("Leo"));

        await rest.saveNewMenu("Papas", 1, 500);

        console.log("Menu created", await rest.getMenu("Papas"));

        await cust.customerAttendedByWaiter("Leo", "Papas");

        console.log("Customer attended", await rest.getOrder("Mesa 10"));
    });
});