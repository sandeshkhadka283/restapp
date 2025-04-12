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

  // List of menu items
  List<MenuItem> menuItems = [
    MenuItem(
      name: 'Burger',
      price: 5.0,
      icon: Icons.fastfood,
      color: Colors.amber,
    ),
    MenuItem(
      name: 'Pizza',
      price: 8.5,
      icon: Icons.local_pizza,
      color: Colors.redAccent,
    ),
    MenuItem(
      name: 'Coke',
      price: 2.0,
      icon: Icons.local_drink,
      color: Colors.blue,
    ),
    MenuItem(name: 'Salad', price: 6.5, icon: Icons.eco, color: Colors.green),
    MenuItem(
      name: 'Pasta',
      price: 7.5,
      icon: Icons.restaurant,
      color: Colors.orange,
    ),
    MenuItem(
      name: 'Ice Cream',
      price: 4.0,
      icon: Icons.icecream,
      color: Colors.pink,
    ),
  ];

  // Color scheme
  Color primaryColor = Color(0xFF6A11CB);
  Color secondaryColor = Color(0xFF2575FC);
  Color accentColor = Color(0xFF00F2FE);
  Color successColor = Color(0xFF4CAF50);
  Color warningColor = Color(0xFFFF9800);
  Color errorColor = Color(0xFFF44336);

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
    return DateFormat('MMM dd, hh:mm a').format(time);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Order - ${widget.table.name}'),
        centerTitle: true,
        flexibleSpace: Container(decoration: BoxDecoration()),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFf5f7fa), Color(0xFFe4e8f0)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Current Order Section
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.shopping_cart, color: primaryColor),
                            SizedBox(width: 8),
                            Text(
                              "Current Order",
                              style: textTheme.titleLarge?.copyWith(
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        items.isEmpty
                            ? Padding(
                              padding: const EdgeInsets.symmetric(vertical: 24),
                              child: Center(
                                child: Text(
                                  "No items added yet",
                                  style: textTheme.bodyLarge?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                            )
                            : Column(
                              children:
                                  items.asMap().entries.map((entry) {
                                    final index = entry.key;
                                    final item = entry.value;
                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 12),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 4,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 40,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    primaryColor.withOpacity(
                                                      0.8,
                                                    ),
                                                    secondaryColor,
                                                  ],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "${index + 1}",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    item.name,
                                                    style: textTheme.titleMedium
                                                        ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                  ),
                                                  Text(
                                                    "\$${item.price.toStringAsFixed(2)} each",
                                                    style: textTheme.bodySmall
                                                        ?.copyWith(
                                                          color:
                                                              Colors.grey[600],
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  "\$${(item.price * item.quantity).toStringAsFixed(2)}",
                                                  style: textTheme.titleMedium
                                                      ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: primaryColor,
                                                      ),
                                                ),
                                                Row(
                                                  children: [
                                                    IconButton(
                                                      icon: Icon(
                                                        Icons
                                                            .remove_circle_outline,
                                                        color: errorColor,
                                                      ),
                                                      onPressed:
                                                          () =>
                                                              decreaseQuantity(
                                                                index,
                                                              ),
                                                      padding: EdgeInsets.zero,
                                                      constraints:
                                                          BoxConstraints(),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 4,
                                                          ),
                                                      child: Text(
                                                        "${item.quantity}",
                                                      ),
                                                    ),
                                                    IconButton(
                                                      icon: Icon(
                                                        Icons
                                                            .add_circle_outline,
                                                        color: successColor,
                                                      ),
                                                      onPressed:
                                                          () =>
                                                              increaseQuantity(
                                                                index,
                                                              ),
                                                      padding: EdgeInsets.zero,
                                                      constraints:
                                                          BoxConstraints(),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                            ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // Order Summary Section
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.receipt, color: primaryColor),
                            SizedBox(width: 8),
                            Text(
                              "Order Summary",
                              style: textTheme.titleLarge?.copyWith(
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        if (orderPlacedAt != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.access_time,
                                  size: 16,
                                  color: Colors.grey[600],
                                ),
                                SizedBox(width: 4),
                                Text(
                                  "Placed: ${formatTime(orderPlacedAt)}",
                                  style: textTheme.bodySmall?.copyWith(
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (billPaidAt != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  size: 16,
                                  color: successColor,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  "Paid: ${formatTime(billPaidAt)}",
                                  style: textTheme.bodySmall?.copyWith(
                                    color: successColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (summary.isNotEmpty) ...[
                          Divider(
                            height: 24,
                            thickness: 1,
                            color: Colors.grey[200],
                          ),
                          Text(
                            summary,
                            style: textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                        Divider(
                          height: 24,
                          thickness: 1,
                          color: Colors.grey[200],
                        ),
                        summaryRow("Subtotal", subtotal),
                        summaryRow("Tax (10%)", tax),
                        Divider(
                          height: 24,
                          thickness: 1,
                          color: Colors.grey[200],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total",
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "\$${grandTotal.toStringAsFixed(2)}",
                              style: textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 24),

                // Action Buttons
                // In your Action Buttons section, replace the existing Row widget with this:

                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient:
                              orderPlacedAt != null
                                  ? null
                                  : LinearGradient(
                                    colors: [primaryColor, secondaryColor],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withOpacity(0.2),
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed:
                              (items.isEmpty || orderPlacedAt != null)
                                  ? null
                                  : () {
                                    setState(() {
                                      orderPlacedAt = DateTime.now();
                                    });
                                  },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                orderPlacedAt != null
                                    ? Colors.grey[300]
                                    : Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                orderPlacedAt != null
                                    ? Icons.check_circle
                                    : Icons.send,
                                color:
                                    orderPlacedAt != null
                                        ? Colors.grey[600]
                                        : Colors.white,
                              ),
                              SizedBox(width: 8),
                              Text(
                                items.isEmpty
                                    ? 'Place Order'
                                    : (orderPlacedAt == null
                                        ? 'Place Order'
                                        : 'Order Placed'),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      orderPlacedAt != null
                                          ? Colors.grey[600]
                                          : Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (orderPlacedAt != null) SizedBox(width: 16),
                    if (orderPlacedAt != null)
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient:
                                billPaid
                                    ? null
                                    : LinearGradient(
                                      colors: [successColor, Color(0xFF8BC34A)],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                            boxShadow: [
                              BoxShadow(
                                color: successColor.withOpacity(0.2),
                                blurRadius: 6,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                billPaid = !billPaid;
                                billPaidAt = billPaid ? DateTime.now() : null;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  billPaid
                                      ? Colors.grey[300]
                                      : Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  billPaid ? Icons.cancel : Icons.attach_money,
                                  color:
                                      billPaid
                                          ? Colors.grey[600]
                                          : Colors.white,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  billPaid ? 'Mark Unpaid' : 'Mark Paid',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        billPaid
                                            ? Colors.grey[600]
                                            : Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),

                SizedBox(height: 24),

                // Menu Button
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) {
                          Map<String, int> selectedQuantities = {};

                          return StatefulBuilder(
                            builder: (context, setModalState) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(24),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 10,
                                      offset: Offset(0, -5),
                                    ),
                                  ],
                                ),
                                padding: EdgeInsets.only(
                                  left: 16,
                                  right: 16,
                                  top: 24,
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom +
                                      16,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Draggable handle
                                    Container(
                                      width: 60,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                    ),
                                    SizedBox(height: 16),

                                    // Header
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Menu Items',
                                            style: textTheme.titleLarge
                                                ?.copyWith(
                                                  color: primaryColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.close),
                                            onPressed:
                                                () => Navigator.pop(context),
                                          ),
                                        ],
                                      ),
                                    ),

                                    SizedBox(height: 16),

                                    // Menu items grid
                                    Expanded(
                                      child: GridView.builder(
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: isTablet ? 3 : 2,
                                              childAspectRatio: 1.1,
                                              crossAxisSpacing: 12,
                                              mainAxisSpacing: 12,
                                            ),
                                        itemCount: menuItems.length,
                                        itemBuilder: (context, index) {
                                          final menuItem = menuItems[index];
                                          final quantity =
                                              selectedQuantities[menuItem
                                                  .name] ??
                                              0;
                                          final safeColor =
                                              menuItem.color ?? Colors.grey;

                                          return GestureDetector(
                                            onTap: () {
                                              setModalState(() {
                                                selectedQuantities[menuItem
                                                        .name] =
                                                    quantity + 1;
                                              });
                                            },
                                            child: Card(
                                              elevation: 2,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Column(
                                                children: [
                                                  // Item image/icon (tappable area)
                                                  Expanded(
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        gradient: LinearGradient(
                                                          colors: [
                                                            safeColor
                                                                .withOpacity(
                                                                  0.8,
                                                                ),
                                                            safeColor,
                                                          ],
                                                          begin:
                                                              Alignment.topLeft,
                                                          end:
                                                              Alignment
                                                                  .bottomRight,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.only(
                                                              topLeft:
                                                                  Radius.circular(
                                                                    12,
                                                                  ),
                                                              topRight:
                                                                  Radius.circular(
                                                                    12,
                                                                  ),
                                                            ),
                                                      ),
                                                      child: Center(
                                                        child: Icon(
                                                          menuItem.icon,
                                                          color: Colors.white,
                                                          size: 32,
                                                        ),
                                                      ),
                                                    ),
                                                  ),

                                                  // Item details and quantity controls
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          menuItem.name,
                                                          style: textTheme
                                                              .titleMedium
                                                              ?.copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                          textAlign:
                                                              TextAlign.center,
                                                          maxLines: 1,
                                                          overflow:
                                                              TextOverflow
                                                                  .ellipsis,
                                                        ),
                                                        SizedBox(height: 4),
                                                        Text(
                                                          "\$${menuItem.price.toStringAsFixed(2)}",
                                                          style: textTheme
                                                              .bodySmall
                                                              ?.copyWith(
                                                                color:
                                                                    Colors
                                                                        .grey[700],
                                                              ),
                                                        ),
                                                        SizedBox(height: 8),

                                                        // Quantity controls row
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            // Decrease button
                                                            InkWell(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    20,
                                                                  ),
                                                              onTap:
                                                                  quantity > 0
                                                                      ? () {
                                                                        setModalState(() {
                                                                          selectedQuantities[menuItem.name] =
                                                                              quantity -
                                                                              1;
                                                                        });
                                                                      }
                                                                      : null,
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                  color:
                                                                      quantity >
                                                                              0
                                                                          ? errorColor.withOpacity(
                                                                            0.2,
                                                                          )
                                                                          : Colors
                                                                              .grey[200],
                                                                  shape:
                                                                      BoxShape
                                                                          .circle,
                                                                ),
                                                                padding:
                                                                    EdgeInsets.all(
                                                                      6,
                                                                    ),
                                                                child: Icon(
                                                                  Icons.remove,
                                                                  size: 18,
                                                                  color:
                                                                      quantity >
                                                                              0
                                                                          ? errorColor
                                                                          : Colors
                                                                              .grey[400],
                                                                ),
                                                              ),
                                                            ),

                                                            // Quantity display
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        12,
                                                                  ),
                                                              child: Text(
                                                                '$quantity',
                                                                style: textTheme
                                                                    .bodyMedium
                                                                    ?.copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                              ),
                                                            ),

                                                            // Increase button
                                                            InkWell(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    20,
                                                                  ),
                                                              onTap: () {
                                                                setModalState(() {
                                                                  selectedQuantities[menuItem
                                                                          .name] =
                                                                      quantity +
                                                                      1;
                                                                });
                                                              },
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                  color: successColor
                                                                      .withOpacity(
                                                                        0.2,
                                                                      ),
                                                                  shape:
                                                                      BoxShape
                                                                          .circle,
                                                                ),
                                                                padding:
                                                                    EdgeInsets.all(
                                                                      6,
                                                                    ),
                                                                child: Icon(
                                                                  Icons.add,
                                                                  size: 18,
                                                                  color:
                                                                      successColor,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),

                                    SizedBox(height: 16),

                                    // Confirm button
                                    Container(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed:
                                            selectedQuantities.values.fold(
                                                      0,
                                                      (sum, qty) => sum + qty,
                                                    ) >
                                                    0
                                                ? () {
                                                  selectedQuantities.forEach((
                                                    name,
                                                    quantity,
                                                  ) {
                                                    if (quantity > 0) {
                                                      final menuItem = menuItems
                                                          .firstWhere(
                                                            (item) =>
                                                                item.name ==
                                                                name,
                                                          );
                                                      for (
                                                        int i = 0;
                                                        i < quantity;
                                                        i++
                                                      ) {
                                                        addItem(
                                                          menuItem.name,
                                                          menuItem.price,
                                                        );
                                                      }
                                                    }
                                                  });
                                                  Navigator.pop(context);
                                                }
                                                : null,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 14,
                                          ),
                                          child: Text(
                                            'Add ${selectedQuantities.values.fold(0, (sum, qty) => sum + qty)} Items',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: primaryColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          elevation: 2,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                    icon: Icon(Icons.menu_book, color: Colors.white),
                    label: Text(
                      'View Menu',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                      backgroundColor: secondaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      shadowColor: secondaryColor.withOpacity(0.3),
                    ),
                  ),
                ),

                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget summaryRow(String label, double amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
          Text(
            "\$${amount.toStringAsFixed(2)}",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }
}

class MenuItem {
  final String name;
  final double price;
  final IconData icon;
  final Color color;

  MenuItem({
    required this.name,
    required this.price,
    required this.icon,
    required this.color,
  });
}
