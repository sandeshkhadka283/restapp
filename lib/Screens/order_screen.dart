// Your imports
import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../models/table_model.dart';
import 'package:intl/intl.dart';

class OrderScreen extends StatefulWidget {
  final RestaurantTable table;

  OrderScreen({required this.table});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  List<OrderItem> items = [];
  DateTime? orderPlacedAt;
  DateTime? billPaidAt;
  bool billPaid = false;

  void addItem(String name, double price) {
    setState(() {
      final index = items.indexWhere((item) => item.name == name);
      if (index != -1) {
        items[index].quantity++;
      } else {
        items.add(OrderItem(name: name, quantity: 1, price: price));
      }
    });
  }

  void increaseQuantity(int index) {
    setState(() {
      items[index].quantity++;
    });
  }

  void decreaseQuantity(int index) {
    setState(() {
      if (items[index].quantity > 1) {
        items[index].quantity--;
      } else {
        items.removeAt(index);
      }
    });
  }

  double get subtotal =>
      items.fold(0, (sum, item) => sum + item.price * item.quantity);

  double get tax => subtotal * 0.10;
  double get grandTotal => subtotal + tax;

  String get summary {
    if (items.isEmpty) return "No items";
    return items.map((item) => "${item.name} x${item.quantity}").join(", ");
  }

  String formatTime(DateTime? time) {
    if (time == null) return '';
    return DateFormat('yyyy-MM-dd hh:mm a').format(time);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final accent = Colors.deepPurple;

    return Scaffold(
      appBar: AppBar(
        title: Text('🧾 Orders - ${widget.table.name}'),
        backgroundColor: accent,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Active Order List
                  if (items.isNotEmpty)
                    Text(
                      "🛒 Current Order Items",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: accent,
                      ),
                    ),
                  SizedBox(height: 8),
                  items.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 40),
                            child: Text(
                              "No items added yet",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                              ),
                            ),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: items.length,
                          itemBuilder: (_, index) {
                            final item = items[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 6,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.name,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: isTablet ? 18 : 16,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            "Unit Price: \$${item.price.toStringAsFixed(2)}",
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          "\$${(item.price * item.quantity).toStringAsFixed(2)}",
                                          style: TextStyle(
                                            fontSize: isTablet ? 18 : 16,
                                            fontWeight: FontWeight.bold,
                                            color: accent,
                                          ),
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              icon: Icon(Icons.remove_circle_outline),
                                              onPressed: () =>
                                                  decreaseQuantity(index),
                                              color: accent,
                                              iconSize: isTablet ? 26 : 20,
                                            ),
                                            Text("${item.quantity}"),
                                            IconButton(
                                              icon: Icon(Icons.add_circle_outline),
                                              onPressed: () =>
                                                  increaseQuantity(index),
                                              color: accent,
                                              iconSize: isTablet ? 26 : 20,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),

                  SizedBox(height: 24),

                  // Summary Section
                  Text(
                    "📋 Order Summary",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: accent,
                    ),
                  ),
                  SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 6),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (orderPlacedAt != null)
                          Text(
                            "🕒 Order Placed At: ${formatTime(orderPlacedAt)}",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[700],
                            ),
                          ),
                        if (billPaidAt != null)
                          Text(
                            "✅ Bill Paid At: ${formatTime(billPaidAt)}",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.green[700],
                            ),
                          ),
                        if (summary.isNotEmpty) ...[
                          SizedBox(height: 8),
                          Text(
                            summary,
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[800]),
                          ),
                        ],
                        Divider(height: 24, thickness: 1),
                        summaryRow("Subtotal", subtotal),
                        summaryRow("Service Tax (10%)", tax),
                        Divider(height: 24, thickness: 1),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "\$${grandTotal.toStringAsFixed(2)}",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24),

                  // Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: orderPlacedAt == null
                            ? () {
                                setState(() {
                                  orderPlacedAt = DateTime.now();
                                });
                              }
                            : null,
                        icon: Icon(Icons.check_circle_outline),
                        label: Text(orderPlacedAt == null
                            ? 'Place Order'
                            : 'Order Placed'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      if (orderPlacedAt != null)
                        ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              billPaid = !billPaid;
                              billPaidAt = billPaid ? DateTime.now() : null;
                            });
                          },
                          icon: Icon(
                            billPaid
                                ? Icons.cancel_outlined
                                : Icons.attach_money_outlined,
                          ),
                          label:
                              Text(billPaid ? 'Mark Unpaid' : 'Mark Paid'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                billPaid ? Colors.grey : Colors.green[700],
                            padding: EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                    ],
                  ),

                  SizedBox(height: 24),

                  // Add Items Section
                  Text(
                    "➕ Add Items",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: accent,
                    ),
                  ),
                  SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: [
                      buildAddButton("Burger", 5.0, Icons.fastfood, accent),
                      buildAddButton("Pizza", 8.5, Icons.local_pizza, accent),
                      buildAddButton("Coke", 2.0, Icons.local_drink, accent),
                    ],
                  ),
                  SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget summaryRow(String label, double amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
          Text(
            "\$${amount.toStringAsFixed(2)}",
            style: TextStyle(fontSize: 14, color: Colors.grey[800]),
          ),
        ],
      ),
    );
  }

  Widget buildAddButton(
    String label,
    double price,
    IconData icon,
    Color color,
  ) {
    return ElevatedButton.icon(
      onPressed: () => addItem(label, price),
      icon: Icon(icon, color: Colors.white),
      label: Text(label, style: TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
