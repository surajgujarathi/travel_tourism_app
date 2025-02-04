import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_tourism_app/demo.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:travel_tourism_app/screens/login_screen.dart';

import 'package:shared_preferences/shared_preferences.dart';

class BeachDetailsScreen extends StatefulWidget {
  final Beach beach;

  const BeachDetailsScreen({Key? key, required this.beach}) : super(key: key);

  @override
  _BeachDetailsScreenState createState() => _BeachDetailsScreenState();
}

class _BeachDetailsScreenState extends State<BeachDetailsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  double _userRating = 0.0;
  bool _isRatingSubmitted = false;
  late SharedPreferences prefs;
  TextEditingController _reviewController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializePrefs();
    _getUserRating();
  }

  Future<void> _initializePrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> _getUserRating() async {
    final userId = _auth.currentUser?.uid;
    if (userId != null) {
      final ratingDoc = await _firestore
          .collection('user_ratings')
          .doc(userId)
          .collection('beaches')
          .doc(widget.beach.id)
          .get();

      if (ratingDoc.exists) {
        setState(() {
          _userRating = ratingDoc['rating'] ?? 0.0;
          _isRatingSubmitted = true;
        });
      }
    }
  }

  Future<void> _rateBeach(double rating) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You need to log in to rate the beach.')),
      );
      return;
    }

    try {
      await _firestore
          .collection('user_ratings')
          .doc(userId)
          .collection('beaches')
          .doc(widget.beach.id)
          .set({
        'rating': rating,
        'beachName': widget.beach.name,
        'timestamp': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      await prefs.setDouble('rating_${widget.beach.id}', rating);

      setState(() {
        _userRating = rating;
        _isRatingSubmitted = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Rating saved successfully!')),
      );
    } catch (e) {
      print('Error saving rating: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving rating: $e')),
      );
    }
  }

  Future<void> _submitReview() async {
    final userId = _auth.currentUser?.uid;
    final review = _reviewController.text.trim();
    if (userId == null || review.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You need to log in and enter a review.')),
      );
      return;
    }

    try {
      await _firestore
          .collection('user_reviews')
          .doc(userId)
          .collection('beaches')
          .doc(widget.beach.id)
          .set({
        'review': review,
        'beachName': widget.beach.name,
        'timestamp': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Review submitted successfully!')),
      );

      // This forces the UI to refresh after submitting the review
      setState(() {
        _reviewController.clear();
      });
    } catch (e) {
      print('Error submitting review: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting review: $e')),
      );
    }
  }

  Future<void> _toggleFavorite() async {
    setState(() {
      widget.beach.isFavorite = !widget.beach.isFavorite;
    });
    await prefs.setBool('favorite_${widget.beach.id}', widget.beach.isFavorite);
  }

  Widget build(BuildContext context) {
    List<String>? beachImages = widget.beach.image;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(widget.beach.name),
              background: CarouselSlider(
                items: beachImages?.map((image) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Image.asset(
                        image,
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width,
                      );
                    },
                  );
                }).toList(),
                options: CarouselOptions(
                  autoPlay: true,
                  enlargeCenterPage: true,
                  aspectRatio: 2.0,
                  viewportFraction: 1.0,
                  initialPage: 0,
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  widget.beach.isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: Colors.red,
                ),
                onPressed: _toggleFavorite,
              ),
              IconButton(
                icon: Icon(
                  Icons.star,
                  color: Colors.yellow,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ReviewsAndWishListScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.beach.location,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        Chip(
                          label: Text(
                            widget.beach.isSuitable
                                ? 'Suitable'
                                : 'Not-Suitable',
                            style: const TextStyle(color: Colors.white),
                          ),
                          backgroundColor: widget.beach.isSuitable
                              ? Colors.green
                              : Colors.red,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    WeatherInfoCard(beach: widget.beach),
                    const SizedBox(height: 16),
                    Text(
                      'About',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.beach.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Activities',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: widget.beach.activities.map((activity) {
                        return Chip(
                          label: Text(activity),
                          avatar: const Icon(Icons.beach_access),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Rate this Beach',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    StarRating(
                      rating: _userRating,
                      onRatingChanged: (rating) {
                        setState(() {
                          _userRating = rating;
                        });
                        _rateBeach(rating);
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _isRatingSubmitted
                          ? null
                          : () {
                              if (_userRating > 0.0) {
                                _rateBeach(_userRating);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Please select a rating!')),
                                );
                              }
                            },
                      child: Text(_isRatingSubmitted
                          ? 'Rating Submitted'
                          : 'Submit Rating'),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Your Rating: ${_userRating.toStringAsFixed(1)}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    // Review Section
                    TextFormField(
                      controller: _reviewController,
                      decoration: InputDecoration(
                        labelText: 'Write a review',
                        border: OutlineInputBorder(),
                        hintText: 'Enter your review here...',
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _submitReview,
                      child: Text('Submit Review'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StarRating extends StatelessWidget {
  final double rating;
  final Function(double) onRatingChanged;

  const StarRating(
      {Key? key, required this.rating, required this.onRatingChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            index < rating.floor() ? Icons.star : Icons.star_border,
            color: Colors.amber,
            size: 40,
          ),
          onPressed: () => onRatingChanged(index + 1.0),
        );
      }),
    );
  }
}

class ReviewsAndWishListScreen extends StatelessWidget {
  const ReviewsAndWishListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    return Scaffold(
      appBar: AppBar(
        title: Text('My Ratings'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('user_reviews') // Fetch reviews
            .doc(_auth.currentUser!.uid)
            .collection('beaches')
            .snapshots(),
        builder: (context, reviewSnapshot) {
          if (reviewSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (reviewSnapshot.hasError) {
            return Center(child: Text('Error: ${reviewSnapshot.error}'));
          }

          if (!reviewSnapshot.hasData || reviewSnapshot.data!.docs.isEmpty) {
            return Center(
                child: Text('You haven\'t reviewed any beaches yet.'));
          }

          return StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection('user_ratings') // Fetch ratings
                .doc(_auth.currentUser!.uid)
                .collection('beaches')
                .snapshots(),
            builder: (context, ratingSnapshot) {
              if (ratingSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (ratingSnapshot.hasError) {
                return Center(child: Text('Error: ${ratingSnapshot.error}'));
              }

              if (!ratingSnapshot.hasData ||
                  ratingSnapshot.data!.docs.isEmpty) {
                return Center(
                    child: Text('You haven\'t rated any beaches yet.'));
              }

              return ListView.builder(
                itemCount: reviewSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var reviewData = reviewSnapshot.data!.docs[index].data()
                      as Map<String, dynamic>;
                  var ratingData = ratingSnapshot.data!.docs[index].data()
                      as Map<String, dynamic>;

                  return Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    elevation: 4,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Text(
                        reviewData['beachName'] ?? 'Unknown Beach',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Display the review
                          Text(
                            'Reviews: ${reviewData['review'] ?? 'No review'}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 8),

                          // Display the rating
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.amber, size: 18),
                              Text(
                                ratingData['rating'] != null
                                    ? ratingData['rating'].toStringAsFixed(1)
                                    : 'No rating',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          // Display the timestamp of the review
                          Text(
                            'Rated on: ${(reviewData['timestamp'] as Timestamp).toDate().toString().split('.')[0]}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
