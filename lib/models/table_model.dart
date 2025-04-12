class RestaurantTable {
  final String id;
  final String name;
  bool isOccupied;

  RestaurantTable({
    required this.id,
    required this.name,
    this.isOccupied = false,
  });
}
