import 'package:flutter/material.dart';
import 'package:couldai_user_app/models/menu_item.dart';
import 'package:couldai_user_app/models/coffee_shop.dart';

class MenuScreen extends StatefulWidget {
  final CoffeeShop shop;

  const MenuScreen({super.key, required this.shop});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final Map<String, int> _cart = {}; // itemId -> quantity

  void _addToCart(String itemId) {
    setState(() {
      _cart[itemId] = (_cart[itemId] ?? 0) + 1;
    });
  }

  void _removeFromCart(String itemId) {
    setState(() {
      if (_cart[itemId] != null && _cart[itemId]! > 0) {
        _cart[itemId] = _cart[itemId]! - 1;
        if (_cart[itemId] == 0) {
          _cart.remove(itemId);
        }
      }
    });
  }

  int _getTotalItems() {
    return _cart.values.fold(0, (sum, qty) => sum + qty);
  }

  double _getTotalPrice() {
    double total = 0;
    _cart.forEach((itemId, qty) {
      final item = widget.shop.menu.firstWhere((i) => i.id == itemId);
      total += item.price * qty;
    });
    return total;
  }

  void _placeOrder() {
    if (_cart.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Your cart is empty!')),
      );
      return;
    }

    // Simulate order placement
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Order Placed!'),
        content: Text('Your order from ${widget.shop.name} has been placed successfully. Total: \$${_getTotalPrice().toStringAsFixed(2)}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              setState(() {
                _cart.clear(); // Clear cart
              });
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Group menu items by category
    final Map<String, List<MenuItem>> categorizedMenu = {};
    for (final item in widget.shop.menu) {
      categorizedMenu[item.category] ??= [];
      categorizedMenu[item.category]!.add(item);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.shop.name} Menu'),
        backgroundColor: Colors.brown[700],
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: categorizedMenu.entries.map((entry) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  entry.key,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.brown[800],
                      ),
                ),
              ),
              ...entry.value.map((item) => MenuItemCard(
                    item: item,
                    quantity: _cart[item.id] ?? 0,
                    onAdd: () => _addToCart(item.id),
                    onRemove: () => _removeFromCart(item.id),
                  )),
            ],
          );
        }).toList(),
      ),n      bottomNavigationBar: _cart.isNotEmpty
          ? Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_getTotalItems()} items',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '\$${_getTotalPrice().toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _placeOrder,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown[700],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                    child: const Text('Place Order'),
                  ),
                ],
              ),
            )
          : null,
    );
  }
}

class MenuItemCard extends StatelessWidget {
  final MenuItem item;
  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const MenuItemCard({
    super.key,
    required this.item,
    required this.quantity,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(item.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.description,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${item.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.brown[700],
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                if (quantity > 0)
                  Text(
                    'Qty: $quantity',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                Row(
                  children: [
                    IconButton(
                      onPressed: onRemove,
                      icon: const Icon(Icons.remove_circle_outline),
                      color: Colors.brown[700],
                    ),
                    IconButton(
                      onPressed: onAdd,
                      icon: const Icon(Icons.add_circle_outline),
                      color: Colors.brown[700],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
