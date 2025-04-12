import 'package:flutter/material.dart';
import '../models/order_model.dart';

class OrderProvider extends ChangeNotifier {
  final Map<String, List<OrderItem>> _orders = {};
  final Map<String, DateTime> _orderTimestamps = {};

  List<OrderItem> getItems(String tableId) => _orders[tableId] ?? [];

  void addItem(String tableId, String name, double price) {
    final items = _orders[tableId] ?? [];
    final index = items.indexWhere((item) => item.name == name);
    if (index != -1) {
      items[index].quantity++;
    } else {
      items.add(OrderItem(name: name, quantity: 1, price: price));
    }
    _orders[tableId] = items;
    _orderTimestamps[tableId] = DateTime.now();
    notifyListeners();
  }

  void increaseQuantity(String tableId, int index) {
    _orders[tableId]?[index].quantity++;
    notifyListeners();
  }

  void decreaseQuantity(String tableId, int index) {
    final items = _orders[tableId];
    if (items != null) {
      if (items[index].quantity > 1) {
        items[index].quantity--;
      } else {
        items.removeAt(index);
      }
    }
    notifyListeners();
  }

  void removeItem(String tableId, int index) {
    _orders[tableId]?.removeAt(index);
    notifyListeners();
  }

  double getTotal(String tableId) {
    final items = _orders[tableId] ?? [];
    return items.fold(0, (sum, item) => sum + item.price * item.quantity);
  }

  String getSummary(String tableId) {
    final items = _orders[tableId] ?? [];
    if (items.isEmpty) return "No items";
    return items.map((item) => "${item.name} x${item.quantity}").join(", ");
  }

  String getFormattedDateTime(String tableId) {
    final timestamp = _orderTimestamps[tableId];
    if (timestamp == null) return "";
    return "${timestamp.year}-${timestamp.month.toString().padLeft(2, '0')}-${timestamp.day.toString().padLeft(2, '0')} "
        "${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}";
  }
}
