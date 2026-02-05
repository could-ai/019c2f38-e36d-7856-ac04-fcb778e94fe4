class MenuItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category; // e.g., 'Coffee', 'Pastries', 'Snacks'
  final String imageUrl;

  MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrl,
  });
}
