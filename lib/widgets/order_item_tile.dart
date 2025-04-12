import 'package:flutter/material.dart';
import '../models/order_model.dart';

class OrderItemTile extends StatelessWidget {
  final OrderItem item;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  OrderItemTile({
    required this.item,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.name),
      subtitle: Text('Qty: ${item.quantity}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Quantity controls
          IconButton(icon: Icon(Icons.remove), onPressed: onRemove),
          Text('${item.quantity}'),
          IconButton(icon: Icon(Icons.add), onPressed: onAdd),
          SizedBox(width: 12),
          Text('\$${(item.price * item.quantity).toStringAsFixed(2)}'),
        ],
      ),
    );
  }
}
