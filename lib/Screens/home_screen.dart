import 'package:flutter/material.dart';
import '../models/table_model.dart';
import 'order_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<RestaurantTable> tables = List.generate(
    12,
    (index) => RestaurantTable(id: 'T${index + 1}', name: 'Table ${index + 1}'),
  );

  int tappedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: const Text(
          '🍽️ Restaurant POS',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        elevation: 4,
        shadowColor: Colors.deepPurple.withOpacity(0.5),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          itemCount: tables.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.9, // slightly taller for better spacing
          ),
          itemBuilder: (context, index) {
            final table = tables[index];
            final isOccupied = table.isOccupied;
            final isTapped = index == tappedIndex;

            return AnimatedScale(
              scale: isTapped ? 0.96 : 1.0,
              duration: const Duration(milliseconds: 120),
              child: Material(
                borderRadius: BorderRadius.circular(16),
                color: isOccupied ? Colors.red.shade100 : Colors.green.shade100,
                elevation: 2,
                shadowColor: Colors.black12,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  splashColor: Colors.deepPurpleAccent.withOpacity(0.2),
                  highlightColor: Colors.deepPurple.withOpacity(0.1),
                  onTap: () {
                    setState(() => tappedIndex = index);
                    Future.delayed(const Duration(milliseconds: 150), () {
                      setState(() => tappedIndex = -1);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => OrderScreen(table: table),
                        ),
                      );
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: LayoutBuilder(
                      builder: (context, constraints) => Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isOccupied ? Icons.event_busy : Icons.event_available,
                            size: constraints.maxHeight * 0.25,
                            color: isOccupied ? Colors.red : Colors.green,
                          ),
                          const SizedBox(height: 6),
                          Flexible(
                            child: Text(
                              table.name,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: isOccupied ? Colors.red[900] : Colors.green[900],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isOccupied ? 'Occupied' : 'Available',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[800],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
