import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_tourism_app/demo.dart';

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

  Future<void> _toggleFavorite() async {
    setState(() {
      widget.beach.isFavorite = !widget.beach.isFavorite;
    });
    await prefs.setBool('favorite_${widget.beach.id}', widget.beach.isFavorite);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(widget.beach.name),
              background: Hero(
                tag: widget.beach.id,
                child: Image.asset(
                  widget.beach.image,
                  fit: BoxFit.cover,
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => ProfileScreen()));
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
                    Center(
                      child: Text(
                        'Your Rating: ${_userRating.toStringAsFixed(1)}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
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

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

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
            .collection('user_ratings')
            .doc(_auth.currentUser!.uid)
            .collection('beaches')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('You haven\'t rated any beaches yet.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var ratingData =
                  snapshot.data!.docs[index].data() as Map<String, dynamic>;
              return ListTile(
                title: Text(ratingData['beachName'] ?? 'Unknown Beach'),
                subtitle: Text(
                    'Rated on: ${(ratingData['timestamp'] as Timestamp).toDate().toString().split('.')[0]}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star, color: Colors.amber),
                    Text(ratingData['rating'].toStringAsFixed(1)),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
