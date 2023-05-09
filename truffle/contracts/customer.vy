# @version ^0.3.7

interface Restaurant:
    def saveNewOrder(in_menu: String[50], in_table: String[50], in_waiter: address, in_customer: String[50]): nonpayable


enum CustomerGender:
    MALE
    FEMALE
    OTHER

enum CustomerStatus:
    ATTENDED
    NOT_ATTENDED
    CHARGED

owner: address

struct Customer:
    name: String[50]
    table: String[50]
    gender: CustomerGender
    status: CustomerStatus

customers: HashMap[String[50], Customer]

@external
def __init__():
    self.owner = msg.sender

@external
def saveNewCustomer(in_name: String[50], in_table: String[50], in_gender: CustomerGender, in_status: CustomerStatus):
    assert msg.sender == self.owner, "Solo el dueño puede agregar clientes"
    customerAux : Customer = self.customers[in_name]
    assert customerAux.name != in_name, "Cliente ya existe"
    customer : Customer = Customer({name: in_name, table: in_table, gender: in_gender, status: in_status})
    self.customers[in_name] = customer

@view
@external
def getCustomer(name: String[50]) -> Customer:
    assert msg.sender == self.owner, "Solo el dueño puede ver los clientes"
    customer : Customer = self.customers[name]
    assert customer.name != empty(String[50]), "Cliente no encontrado"
    return customer

@external
def changeStatus(name: String[50], status: CustomerStatus): 
    customer : Customer = self.customers[name]
    assert customer.name != empty(String[50]), "Cliente no encontrado"
    customer.status = status

@external
def changeTable(name: String[50], table: String[50]):
    customer : Customer = self.customers[name]
    assert customer.name != empty(String[50]), "Cliente no encontrado"
    customer.table = table

@external
def customerAttendedByWaiter(in_name: String[50], in_menu: String[50], in_waiter: address):
    customer : Customer = self.customers[in_name]
    assert customer.name != empty(String[50]), "Cliente no encontrado"
    customer.status = CustomerStatus.ATTENDED
    restaurant : Restaurant = Restaurant(in_waiter)
    restaurant.saveNewOrder(in_menu, customer.table, in_waiter, customer.name)
