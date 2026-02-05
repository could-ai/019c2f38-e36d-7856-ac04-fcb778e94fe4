class Review {
  final String id;
  final String shopId;
  final String userName;
  final double rating;
  final String comment;
  final DateTime date;

  Review({
    required this.id,
    required this.shopId,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.date,
  });
}
