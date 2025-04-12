import 'package:flutter/material.dart';
import '../models/table_model.dart';

class TableCard extends StatelessWidget {
  final RestaurantTable table;
  final Function onTap;

  TableCard({required this.table, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: table.isOccupied ? Colors.red[200] : Colors.green[200],
      child: InkWell(
        onTap: () => onTap(),
        child: Center(
          child: Text(
            table.name,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
