import 'package:flutter/material.dart';
import 'package:couldai_user_app/models/coffee_shop.dart';

class CoffeeCard extends StatelessWidget {
  final CoffeeShop shop;
  final VoidCallback onTap;

  const CoffeeCard({
    super.key,
    required this.shop,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Placeholder or Network Image
            Container(
              height: 150,
              width: double.infinity,
              color: Colors.grey[300],
              child: Image.network(
                shop.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(child: Icon(Icons.coffee, size: 50, color: Colors.brown));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          shop.name,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.amber[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star, size: 16, color: Colors.amber),
                            const SizedBox(width: 4),
                            Text(
                              shop.rating.toString(),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    shop.address,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        '${shop.distance} km away',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const Spacer(),
                      Icon(Icons.thumb_up_alt_outlined, size: 16, color: Colors.brown[300]),
                      const SizedBox(width: 4),
                      Text(
                        '${shop.upvotes}',
                        style: TextStyle(color: Colors.brown[300]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
