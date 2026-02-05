import 'package:couldai_user_app/models/menu_item.dart';

class CoffeeShop {
  final String id;
  final String name;
  final String address;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final double distance; // in km
  final String description;
  int upvotes;
  final List<MenuItem> menu;

  CoffeeShop({
    required this.id,
    required this.name,
    required this.address,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.distance,
    required this.description,
    this.upvotes = 0,
    required this.menu,
  });
}
