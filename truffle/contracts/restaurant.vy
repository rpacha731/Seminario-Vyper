# @version ^0.3.7

enum OrderStatus:
    ENQUEUED
    IN_PREPARATION
    COOCKED
    SERVED

enum MenuType:
    STARTER
    MAIN_COURSE
    DESSERT
    DRINK

owner: address

struct Order:
    status: OrderStatus
    menu: String[50]
    table: String[50]
    waiter: address
    chef: address
    customer: String[50]

struct Menu:
    name: String[50]
    menuType: MenuType
    price: uint256

menus: HashMap[String[50], Menu]
orders: HashMap[String[50], Order]

@external
def __init__():
    self.owner = msg.sender

@external
def saveNewMenu(in_name: String[50], in_menuType: MenuType, in_price: uint256):
    assert msg.sender == self.owner, "Solo el dueño puede agregar platos al menu"
    menuAux: Menu = self.menus[in_name]
    assert menuAux.name != in_name, "Ya existe ese plato en el menu"
    menu: Menu = Menu({
        name: in_name,
        menuType: in_menuType,
        price: in_price
    })
    self.menus[menu.name] = menu

@external
def changeStateOrder(table: String[50], status: OrderStatus):
    order : Order = self.orders[table]
    assert order.waiter != empty(address), "No hay orden para esa mesa, pregunte al mesero"
    order.status = status

@external
def saveNewOrder(in_menu: String[50], in_table: String[50], in_waiter: address, in_customer: String[50]):
    orderAux: Order = self.orders[in_table]
    assert orderAux.waiter == empty(address), "Ya existe una orden para esa mesa"
    order: Order = Order({
        status: OrderStatus.ENQUEUED,
        menu: in_menu,
        table: in_table,
        waiter: in_waiter,
        chef: empty(address),
        customer: in_customer
    })
    self.orders[order.table] = order

@view
@external
def getOrder(table: String[50]) -> Order:
    order: Order = self.orders[table]
    assert order.waiter != empty(address), "No hay orden para esa mesa, pregunte al mesero"
    return order

@view
@external
def getMenu(name: String[50]) -> Menu:
    menu: Menu = self.menus[name]
    assert menu.name != empty(String[50]), "No existe ese plato en el menu"
    return menu