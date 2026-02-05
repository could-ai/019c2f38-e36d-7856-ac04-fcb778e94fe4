import 'package:flutter/material.dart';
import 'package:couldai_user_app/models/coffee_shop.dart';
import 'package:couldai_user_app/models/review.dart';
import 'package:couldai_user_app/services/mock_data_service.dart';

class DetailsScreen extends StatefulWidget {
  final CoffeeShop shop;

  const DetailsScreen({super.key, required this.shop});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final MockDataService _dataService = MockDataService();
  List<Review> _reviews = [];
  bool _isLoadingReviews = true;
  bool _hasUpvoted = false; // Local state for immediate feedback

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    final reviews = await _dataService.getReviewsForShop(widget.shop.id);
    if (mounted) {
      setState(() {
        _reviews = reviews;
        _isLoadingReviews = false;
      });
    }
  }

  void _handleUpvote() {
    if (_hasUpvoted) return; // Prevent multiple upvotes in this session for demo
    
    setState(() {
      _hasUpvoted = true;
      widget.shop.upvotes++; // Optimistic update
    });
    
    _dataService.upvoteShop(widget.shop.id);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Thanks for upvoting!')),
    );
  }

  void _showAddReviewDialog() {
    final commentController = TextEditingController();
    double rating = 5.0;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Write a Review'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Rate this place:'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < rating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                        ),
                        onPressed: () {
                          setState(() {
                            rating = index + 1.0;
                          });
                        },
                      );
                    }),
                  ),
                  TextField(
                    controller: commentController,
                    decoration: const InputDecoration(
                      hintText: 'Share your experience...',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (commentController.text.isNotEmpty) {
                      final newReview = Review(
                        id: DateTime.now().toString(),
                        shopId: widget.shop.id,
                        userName: 'You', // Placeholder user
                        rating: rating,
                        comment: commentController.text,
                        date: DateTime.now(),
                      );
                      
                      await _dataService.addReview(newReview);
                      if (mounted) {
                        Navigator.pop(context);
                        _loadReviews(); // Reload reviews
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Review added!')),
                        );
                      }
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
            floating: false,
            pinned: true,
            backgroundColor: Colors.brown[700],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(widget.shop.name, style: const TextStyle(color: Colors.white, shadows: [Shadow(color: Colors.black, blurRadius: 10)])),
              background: Image.network(
                widget.shop.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.shop.address,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey[700]),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.amber, size: 20),
                              const SizedBox(width: 4),
                              Text(
                                '${widget.shop.rating} (${widget.shop.reviewCount} reviews)',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                      ElevatedButton.icon(
                        onPressed: _hasUpvoted ? null : _handleUpvote,
                        icon: Icon(_hasUpvoted ? Icons.thumb_up : Icons.thumb_up_outlined),
                        label: Text(_hasUpvoted ? 'Upvoted' : 'Upvote'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown[50],
                          foregroundColor: Colors.brown[800],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'About',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(widget.shop.description),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Reviews',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: _showAddReviewDialog,
                        child: const Text('Write a Review'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          _isLoadingReviews
              ? const SliverToBoxAdapter(child: Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator())))
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final review = _reviews[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.brown[200],
                          child: Text(review.userName[0]),
                        ),
                        title: Text(review.userName),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: List.generate(5, (starIndex) {
                                return Icon(
                                  starIndex < review.rating ? Icons.star : Icons.star_border,
                                  size: 14,
                                  color: Colors.amber,
                                );
                              }),
                            ),
                            const SizedBox(height: 4),
                            Text(review.comment),
                          ],
                        ),
                        isThreeLine: true,
                      );
                    },
                    childCount: _reviews.length,
                  ),
                ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 50)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddReviewDialog,
        backgroundColor: Colors.brown[700],
        child: const Icon(Icons.rate_review, color: Colors.white),
      ),
    );
  }
}
