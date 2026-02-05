import 'package:flutter/material.dart';
import 'package:couldai_user_app/models/coffee_shop.dart';
import 'package:couldai_user_app/services/mock_data_service.dart';
import 'package:couldai_user_app/widgets/coffee_card.dart';
import 'package:couldai_user_app/screens/details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MockDataService _dataService = MockDataService();
  List<CoffeeShop> _shops = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadShops();
  }

  Future<void> _loadShops() async {
    setState(() => _isLoading = true);
    final shops = await _dataService.getShops();
    setState(() {
      _shops = shops;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coffee Finder'),
        backgroundColor: Colors.brown[700],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Placeholder for search functionality
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadShops,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _shops.length,
                itemBuilder: (context, index) {
                  final shop = _shops[index];
                  return CoffeeCard(
                    shop: shop,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailsScreen(shop: shop),
                        ),
                      );
                      // Refresh state when returning (in case of upvotes/reviews)
                      _loadShops();
                    },
                  );
                },
              ),
            ),
    );
  }
}
