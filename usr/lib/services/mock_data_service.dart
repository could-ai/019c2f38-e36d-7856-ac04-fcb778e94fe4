import 'package:couldai_user_app/models/coffee_shop.dart';
import 'package:couldai_user_app/models/review.dart';

class MockDataService {
  // Singleton pattern for simple state management in this demo
  static final MockDataService _instance = MockDataService._internal();
  factory MockDataService() => _instance;
  MockDataService._internal();

  final List<CoffeeShop> _shops = [
    CoffeeShop(
      id: '1',
      name: 'Brewed Awakening',
      address: '123 Espresso Lane',
      imageUrl: 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      rating: 4.8,
      reviewCount: 124,
      distance: 0.5,
      description: 'Artisan coffee shop with a cozy atmosphere and house-roasted beans.',
      upvotes: 45,
    ),
    CoffeeShop(
      id: '2',
      name: 'The Daily Grind',
      address: '456 Latte Ave',
      imageUrl: 'https://images.unsplash.com/photo-1554118811-1e0d58224f24?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      rating: 4.2,
      reviewCount: 89,
      distance: 1.2,
      description: 'Fast service and great pastries. Perfect for a quick morning stop.',
      upvotes: 23,
    ),
    CoffeeShop(
      id: '3',
      name: 'Bean There, Done That',
      address: '789 Mocha Blvd',
      imageUrl: 'https://images.unsplash.com/photo-1497935586351-b67a49e012bf?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      rating: 4.5,
      reviewCount: 210,
      distance: 2.5,
      description: 'Spacious seating area, great for working remotely. Free high-speed WiFi.',
      upvotes: 112,
    ),
    CoffeeShop(
      id: '4',
      name: 'Steamy Cups',
      address: '321 Cappuccino Ct',
      imageUrl: 'https://images.unsplash.com/photo-1559925393-8be0ec4767c8?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      rating: 3.9,
      reviewCount: 45,
      distance: 0.8,
      description: 'Classic diner-style coffee with unlimited refills on drip coffee.',
      upvotes: 12,
    ),
    CoffeeShop(
      id: '5',
      name: 'Espresso Yourself',
      address: '654 Macchiato Way',
      imageUrl: 'https://images.unsplash.com/photo-1525610553991-2bede1a236e2?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      rating: 4.9,
      reviewCount: 342,
      distance: 3.1,
      description: 'Award-winning baristas and exotic single-origin beans.',
      upvotes: 250,
    ),
  ];

  final List<Review> _reviews = [
    Review(
      id: 'r1',
      shopId: '1',
      userName: 'Alice M.',
      rating: 5.0,
      comment: 'Best latte in town! The foam art was incredible.',
      date: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Review(
      id: 'r2',
      shopId: '1',
      userName: 'Bob D.',
      rating: 4.0,
      comment: 'Great coffee, but a bit pricey.',
      date: DateTime.now().subtract(const Duration(days: 5)),
    ),
    Review(
      id: 'r3',
      shopId: '2',
      userName: 'Charlie',
      rating: 3.5,
      comment: 'Okay coffee, but the croissants are amazing.',
      date: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  Future<List<CoffeeShop>> getShops() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return _shops;
  }

  Future<List<Review>> getReviewsForShop(String shopId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _reviews.where((r) => r.shopId == shopId).toList();
  }

  Future<void> addReview(Review review) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _reviews.insert(0, review);
  }

  Future<void> upvoteShop(String shopId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final shop = _shops.firstWhere((s) => s.id == shopId);
    shop.upvotes++;
  }
}
