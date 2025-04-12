class OrderItem {
  final String name;
  int quantity;
  final double price;

  OrderItem({required this.name, required this.quantity, required this.price});
}

class Order {
  final String tableId;
  List<OrderItem> items;

  Order({required this.tableId, required this.items});

  double get total {
    return items.fold(0, (sum, item) => sum + item.quantity * item.price);
  }
}
