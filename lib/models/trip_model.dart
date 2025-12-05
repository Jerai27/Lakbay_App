class Trip {
  final String title;
  final String destination;
  final String startDate;
  final String endDate;
  final String budget;
  final String image;

  Trip({
    required this.title,
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.budget,
    this.image = 'assets/images/default_trip.jpg',
  });
}
