class RestaurantTable {
  final String id;
  final String name;
  bool? isOccupied;
  int? numberOfSeats;
  double? reservationAmount;
  String? serverName;

  RestaurantTable({
    required this.id,
    required this.name,
    this.isOccupied,
    this.numberOfSeats,
    this.reservationAmount,
    this.serverName,
  });
}
