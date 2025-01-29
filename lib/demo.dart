import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_tourism_app/Screens/beach_details_screen.dart';

// void main() {
//   runApp(const CoastalTourismApp());
// }

// class CoastalTourismApp extends StatelessWidget {
//   const CoastalTourismApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Coastal Tourism',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         useMaterial3: true,
//         colorScheme: ColorScheme.fromSeed(
//           seedColor: const Color(0xFF0077BE),
//           brightness: Brightness.light,
//         ),
//       ),
//       home: const HomeScreen(),
//     );
//   }
// }

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final TextEditingController _searchController = TextEditingController();
//   List<Beach> filteredBeaches = List.from(beaches);

//   void _filterBeaches(String query) {
//     setState(() {
//       filteredBeaches = beaches
//           .where((beach) =>
//               beach.name.toLowerCase().contains(query.toLowerCase()) ||
//               beach.location.toLowerCase().contains(query.toLowerCase()))
//           .toList();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: CustomScrollView(
//         slivers: [
//           SliverAppBar(
//             backgroundColor: Colors.blueAccent,
//             expandedHeight: 200.0,
//             floating: false,
//             pinned: true,
//             flexibleSpace: FlexibleSpaceBar(
//               title: const Text(
//                 'Indian Coastal Tourism',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               background: Image.asset(
//                 'assets/radanagar.jpg',
//                 fit: BoxFit.cover,
//               ),
//             ),
//             actions: [
//               IconButton(
//                 icon: const Icon(
//                   Icons.favorite,
//                   color: Colors.red,
//                 ),
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => const WishlistScreen()),
//                   );
//                 },
//               ),
//             ],
//           ),
//           SliverToBoxAdapter(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Discover Safe and Beautiful Beaches',
//                     style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.blue.shade800,
//                         ),
//                   ),
//                   const SizedBox(height: 16),
//                   TextField(
//                     controller: _searchController,
//                     decoration: InputDecoration(
//                       hintText: 'Search beaches...',
//                       prefixIcon: const Icon(Icons.search),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       filled: true,
//                       fillColor: Colors.grey.shade100,
//                     ),
//                     onChanged: _filterBeaches,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           SliverList(
//             delegate: SliverChildBuilderDelegate(
//               (context, index) {
//                 final beach = filteredBeaches[index];
//                 return BeachCard(
//                   beach: beach,
//                   onTap: () {
//                     // Navigator.push(
//                     //   context,
//                     //   MaterialPageRoute(
//                     //     builder: (context) => BeachDetailsScreen(beach: beach),
//                     //   ),
//                     // );
//                   },
//                 );
//               },
//               childCount: filteredBeaches.length,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class BeachDetailsScreen extends StatefulWidget {
//   final Beach beach;

//   const BeachDetailsScreen({
//     Key? key,
//     required this.beach,
//   }) : super(key: key);

//   @override
//   State<BeachDetailsScreen> createState() => _BeachDetailsScreenState();
// }

// class _BeachDetailsScreenState extends State<BeachDetailsScreen> {
//   late SharedPreferences prefs;

//   @override
//   void initState() {
//     super.initState();
//     _initPrefs();
//   }

//   Future<void> _initPrefs() async {
//     prefs = await SharedPreferences.getInstance();
//     final isFavorite = prefs.getBool('favorite_${widget.beach.id}') ?? false;
//     setState(() {
//       widget.beach.isFavorite = isFavorite;
//     });
//   }

//   Future<void> _toggleFavorite() async {
//     setState(() {
//       widget.beach.isFavorite = !widget.beach.isFavorite;
//     });
//     await prefs.setBool('favorite_${widget.beach.id}', widget.beach.isFavorite);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: CustomScrollView(
//         slivers: [
//           SliverAppBar(
//             expandedHeight: 300,
//             pinned: true,
//             flexibleSpace: FlexibleSpaceBar(
//               title: Text(widget.beach.name),
//               background: Hero(
//                 tag: widget.beach.id,
//                 child: Image.asset(
//                   widget.beach.image,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             actions: [
//               IconButton(
//                 icon: Icon(
//                   widget.beach.isFavorite
//                       ? Icons.favorite
//                       : Icons.favorite_border,
//                   color: Colors.red,
//                 ),
//                 onPressed: _toggleFavorite,
//               ),
//             ],
//           ),
//           SliverToBoxAdapter(
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Expanded(
//                         child: Text(
//                           widget.beach.location,
//                           style: Theme.of(context).textTheme.titleLarge,
//                         ),
//                       ),
//                       Chip(
//                         label: Text(
//                           widget.beach.isSuitable ? 'Suitable' : 'Not-Suitable',
//                           style: const TextStyle(color: Colors.white),
//                         ),
//                         backgroundColor:
//                             widget.beach.isSuitable ? Colors.green : Colors.red,
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 16),
//                   WeatherInfoCard(beach: widget.beach),
//                   const SizedBox(height: 16),
//                   Text(
//                     'About',
//                     style: Theme.of(context).textTheme.titleLarge,
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     widget.beach.description,
//                     style: Theme.of(context).textTheme.bodyMedium,
//                   ),
//                   const SizedBox(height: 16),
//                   Text(
//                     'Activities',
//                     style: Theme.of(context).textTheme.titleLarge,
//                   ),
//                   const SizedBox(height: 8),
//                   Wrap(
//                     spacing: 8,
//                     children: widget.beach.activities.map((activity) {
//                       return Chip(
//                         label: Text(activity),
//                         avatar: const Icon(Icons.beach_access),
//                       );
//                     }).toList(),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class BeachCard extends StatelessWidget {
  final Beach beach;
  final VoidCallback onTap;

  const BeachCard({
    Key? key,
    required this.beach,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      clipBehavior: Clip.antiAlias,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: beach.id,
              child: Image.asset(
                beach.image,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          beach.name,
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue.shade800,
                                  ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(
                        Icons.circle,
                        color: beach.isSuitable ? Colors.green : Colors.red,
                        size: 12,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    beach.location,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.grey.shade700,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    beach.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade600,
                        ),
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

class WeatherInfoCard extends StatelessWidget {
  final Beach beach;

  const WeatherInfoCard({
    Key? key,
    required this.beach,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildInfoItem(
              context,
              Icons.waves,
              'Wave Height',
              '${beach.waveHeight}m',
            ),
            _buildInfoItem(
              context,
              Icons.air,
              'Wind Speed',
              '${beach.windSpeed}km/h',
            ),
            _buildInfoItem(
              context,
              Icons.water_drop,
              'Water Quality',
              beach.waterQuality,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).primaryColor),
        const SizedBox(height: 8),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({Key? key}) : super(key: key);

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  List<Beach> wishlistBeaches = [];

  @override
  void initState() {
    super.initState();
    _loadWishlist();
  }

  Future<void> _loadWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      wishlistBeaches = beaches.where((beach) {
        return prefs.getBool('favorite_${beach.id}') ?? false;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text('My Wishlist'),
      ),
      body: wishlistBeaches.isEmpty
          ? const Center(
              child: Text('Your wishlist is empty'),
            )
          : ListView.builder(
              itemCount: wishlistBeaches.length,
              itemBuilder: (context, index) {
                return BeachCard(
                  beach: wishlistBeaches[index],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            BeachDetailsScreen(beach: wishlistBeaches[index]),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

class Beach {
  final String id;
  final String name;
  final String image;
  final String location;
  final double waveHeight;
  final double windSpeed;
  final String description;
  final List<String> activities;
  bool isFavorite;
  double rating;

  Beach({
    required this.id,
    required this.name,
    required this.image,
    required this.location,
    required this.waveHeight,
    required this.windSpeed,
    required this.description,
    required this.activities,
    this.isFavorite = false,
    this.rating = 0.0,
  });

  String get waterQuality {
    return SuitabilityAlgorithm.evaluateWaterQuality({
      'current': {'wave_height': waveHeight, 'wind_speed': windSpeed}
    });
  }

  bool get isSuitable => waterQuality == 'Good';
}

final List<Beach> beaches = [
  Beach(
    id: '1',
    name: 'Calangute Beach',
    image: 'assets/goa.jpg',
    location: 'Goa',
    waveHeight: 0.5,
    windSpeed: 100,
    description:
        'Known as the Queen of Beaches, Calangute is the largest beach in North Goa. '
        'It is famous for its golden sand, vibrant nightlife, and water sports activities. '
        'It attracts thousands of tourists annually and is ideal for both relaxation and adventure.',
    activities: ['Swimming', 'Parasailing', 'Jet Skiing', 'Sunbathing'],
  ),
  Beach(
    id: '2',
    name: 'Marina Beach',
    image: 'assets/marina.webp',
    location: 'Chennai',
    waveHeight: 1.2,
    windSpeed: 15,
    description:
        'Marina Beach is a natural urban beach along the Bay of Bengal, and is one of the longest beaches in the world. '
        'Located in Chennai, this beach is known for its wide promenade, historical landmarks, and the iconic lighthouse. '
        'It is a popular spot for morning walks, sunset views, and local street food.',
    activities: [
      'Beach Walking',
      'Kite Flying',
      'Photography',
      'Street Food Tasting'
    ],
  ),
  Beach(
    id: '3',
    name: 'Varkala Beach',
    image: 'assets/varkala.jpg',
    location: 'Kerala',
    waveHeight: 0.8,
    windSpeed: 12,
    description:
        'Varkala Beach is a hidden gem in Kerala, known for its stunning cliffs that rise dramatically over the Arabian Sea. '
        'The beach is famous for its pristine waters, Ayurveda resorts, and the Papanasam beach, where people come for ritualistic dips. '
        'It offers a peaceful atmosphere for travelers looking to relax and unwind.',
    activities: [
      'Cliff Walking',
      'Ayurvedic Treatments',
      'Surfing',
      'Meditation'
    ],
  ),
  Beach(
    id: '4',
    name: 'Baga Beach',
    image: 'assets/baga.jpg',
    location: 'Goa',
    waveHeight: 1.0,
    windSpeed: 18,
    description:
        'Baga Beach is one of the most popular beaches in North Goa, known for its lively atmosphere and vibrant nightlife. '
        'With its beach shacks, water sports, and lively crowd, Baga offers a perfect blend of relaxation and excitement. '
        'It is also famous for its seafood and beach parties.',
    activities: [
      'Beach Parties',
      'Water Sports',
      'Sunbathing',
      'Seafood Tasting'
    ],
  ),
  Beach(
    id: '5',
    name: 'Kovalam Beach',
    image: 'assets/kovalam.jpg',
    location: 'Kerala',
    waveHeight: 1.5,
    windSpeed: 20,
    description:
        'Kovalam Beach is a world-renowned beach in Kerala, known for its crescent-shaped coastline and calm waters. '
        'The beach is famous for its lighthouses, clear waters, and golden sand, making it a popular spot for sunbathing and swimming. '
        'It is also a hub for Ayurvedic treatments and wellness resorts.',
    activities: [
      'Sunbathing',
      'Swimming',
      'Lighthouse Visits',
      'Ayurvedic Treatments'
    ],
  ),
  Beach(
    id: '6',
    name: 'Radhanagar Beach',
    image: 'assets/radanagar.jpg',
    location: 'Andaman Islands',
    waveHeight: 1.0,
    windSpeed: 10,
    description:
        'Radhanagar Beach is located on Havelock Island in the Andaman and Nicobar Islands. '
        'Known for its pristine beauty, turquoise waters, and white sandy shores, it has been named one of the best beaches in Asia. '
        'The beach is perfect for swimming, sunbathing, and watching stunning sunsets.',
    activities: ['Swimming', 'Snorkeling', 'Sunbathing', 'Sunset Watching'],
  ),
  Beach(
    id: '7',
    name: 'Palolem Beach',
    image: 'assets/palolem.jpg',
    location: 'Goa',
    waveHeight: 0.6,
    windSpeed: 14,
    description:
        'Palolem Beach is a picturesque beach located in South Goa, famous for its crescent-shaped shoreline and calm waters. '
        'It is known for its laid-back vibe, beach huts, and vibrant nightlife. '
        'The beach is ideal for swimming, kayaking, and dolphin watching.',
    activities: ['Kayaking', 'Dolphin Watching', 'Sunbathing', 'Beach Huts'],
  ),
  Beach(
    id: '8',
    name: 'Anjuna Beach',
    image: 'assets/anjuna.webp',
    location: 'Goa',
    waveHeight: 1.2,
    windSpeed: 17,
    description:
        'Anjuna Beach is one of the most iconic beaches in Goa, famous for its bohemian vibe, trance parties, and rave culture. '
        'It is a favorite among backpackers and party-goers. '
        'The beach is also known for its beautiful sunsets and vibrant flea markets.',
    activities: ['Beach Parties', 'Shopping', 'Photography', 'Sunset Watching'],
  ),
  Beach(
    id: '9',
    name: 'Benaulim Beach',
    image: 'assets/Benaulim.jpg',
    location: 'Goa',
    waveHeight: 0.4,
    windSpeed: 8,
    description:
        'Benaulim Beach is a serene and peaceful beach located in South Goa. '
        'With its golden sands and clear waters, it is perfect for a relaxing day away from the crowds. '
        'The beach is ideal for sunbathing, swimming, and enjoying the tranquil atmosphere.',
    activities: ['Swimming', 'Sunbathing', 'Beach Walking', 'Relaxation'],
  ),
  Beach(
    id: '10',
    name: 'Mandrem Beach',
    image: 'assets/mandrem.jpg',
    location: 'Goa',
    waveHeight: 0.3,
    windSpeed: 10,
    description:
        'Mandrem Beach is a quiet and serene beach in North Goa, known for its soft sand and clear waters. '
        'It is a great spot for those seeking peace and solitude, and is perfect for swimming and sunbathing. '
        'The beach is surrounded by palm trees and is a haven for nature lovers.',
    activities: ['Swimming', 'Sunbathing', 'Nature Walks', 'Relaxation'],
  ),
  Beach(
    id: '11',
    name: 'Mandarmani Beach',
    image: 'assets/mandarmani.jpg',
    location: 'West Bengal',
    waveHeight: 0.7,
    windSpeed: 10,
    description:
        'Mandarmani Beach is a serene getaway located in West Bengal, known for its tranquil environment and long motorable beach. '
        'It is perfect for a peaceful retreat away from the city’s hustle and bustle. The beach is famous for its sunrise views and water sports activities.',
    activities: [
      'Beach Driving',
      'Jet Skiing',
      'Sunrise Watching',
      'Relaxation'
    ],
  ),
  Beach(
    id: '12',
    name: 'Kapu Beach',
    image: 'assets/kapu.jpg.webp',
    location: 'Karnataka',
    waveHeight: 0.9,
    windSpeed: 12,
    description:
        'Kapu Beach is a hidden gem in Karnataka, famous for its iconic lighthouse and golden sandy shores. '
        'The beach offers stunning views of the Arabian Sea and is an excellent spot for photography and sunset watching.',
    activities: ['Lighthouse Visits', 'Photography', 'Sunset Watching'],
  ),
  Beach(
    id: '13',
    name: 'Gokarna Beach',
    image: 'assets/gokarana.jpeg',
    location: 'Karnataka',
    waveHeight: 1.0,
    windSpeed: 15,
    description:
        'Gokarna Beach is a spiritual and serene destination in Karnataka, known for its religious significance and pristine coastline. '
        'It is a popular destination for backpackers seeking peace and yoga retreats.',
    activities: ['Yoga', 'Beach Trekking', 'Meditation', 'Temple Visits'],
  ),
  Beach(
    id: '14',
    name: 'Auroville Beach',
    image: 'assets/auroville.jpg',
    location: 'Pondicherry',
    waveHeight: 0.6,
    windSpeed: 8,
    description:
        'Auroville Beach, also known as Auro Beach, is located near the experimental township of Auroville in Pondicherry. '
        'It is famous for its shallow waters, golden sands, and peaceful ambiance, making it ideal for swimming and relaxation.',
    activities: ['Swimming', 'Beach Walking', 'Meditation', 'Relaxation'],
  ),
  Beach(
    id: '15',
    name: 'Paradise Beach',
    image: 'assets/paradise.jpeg',
    location: 'Pondicherry',
    waveHeight: 0.5,
    windSpeed: 7,
    description:
        'Paradise Beach in Pondicherry is a secluded haven, accessible only by a short boat ride. '
        'It is known for its soft golden sands and calm waters, offering a perfect escape for nature lovers and solitude seekers.',
    activities: ['Boating', 'Fishing', 'Picnicking', 'Photography'],
  ),
  Beach(
    id: '16',
    name: 'Ramakrishna Beach',
    image: 'assets/rk.jpg',
    location: 'Visakhapatnam',
    waveHeight: 1.3,
    windSpeed: 10,
    description:
        'Ramakrishna Beach, also known as RK Beach, is a bustling destination in Visakhapatnam. '
        'It is popular for its scenic views, local food stalls, and cultural events. The beach is ideal for families and evening outings.',
    activities: ['Beach Walking', 'Local Cuisine', 'Boating', 'Relaxation'],
  ),
  Beach(
    id: '17',
    name: 'Tarkarli Beach',
    image: 'assets/tarkarli.jpg',
    location: 'Maharashtra',
    waveHeight: 0.8,
    windSpeed: 12,
    description:
        'Tarkarli Beach in Maharashtra is a pristine destination known for its crystal-clear waters and coral reefs. '
        'It is a paradise for adventure seekers, offering a variety of water sports and scuba diving opportunities.',
    activities: ['Scuba Diving', 'Snorkeling', 'Jet Skiing', 'Houseboat Stays'],
  ),
  Beach(
    id: '18',
    name: 'Ganpatipule Beach',
    image: 'assets/ganapatipule.jpeg.webp',
    location: 'Maharashtra',
    waveHeight: 1.1,
    windSpeed: 14,
    description:
        'Ganpatipule Beach is a serene and culturally rich destination in Maharashtra, known for its scenic beauty and the famous Ganpati Temple. '
        'The beach offers a peaceful retreat and is surrounded by lush greenery.',
    activities: ['Temple Visits', 'Swimming', 'Photography', 'Relaxation'],
  ),
  Beach(
    id: '19',
    name: 'Bangaram Beach',
    image: 'assets/bangaram.jpeg',
    location: 'Lakshadweep',
    waveHeight: 0.4,
    windSpeed: 6,
    description:
        'Bangaram Beach is a secluded paradise in Lakshadweep, known for its turquoise waters, coral reefs, and marine life. '
        'It is a dream destination for snorkeling and diving enthusiasts.',
    activities: ['Snorkeling', 'Diving', 'Fishing', 'Relaxation'],
  ),
  Beach(
    id: '20',
    name: 'Om Beach',
    image: 'assets/om.webp',
    location: 'Karnataka',
    waveHeight: 0.9,
    windSpeed: 11,
    description:
        'Om Beach in Gokarna is uniquely shaped like the Hindu symbol "Om." '
        'It is a tranquil spot, popular among spiritual seekers and adventure enthusiasts. The beach offers stunning views and a peaceful atmosphere.',
    activities: ['Trekking', 'Meditation', 'Kayaking', 'Photography'],
  ),
  Beach(
    id: '21',
    name: 'Dhanushkodi Beach',
    image: 'assets/Dhanushkodi.webp',
    location: 'Rameshwaram',
    waveHeight: 0.3,
    windSpeed: 8,
    description:
        'Dhanushkodi Beach is a serene and mystical destination located at the southern tip of Rameshwaram. '
        'Known as the Ghost Town, it offers stunning views of the Bay of Bengal and the Indian Ocean meeting. '
        'It is a peaceful spot for travelers seeking solitude.',
    activities: ['Beach Walking', 'Photography', 'Relaxation'],
  ),
  Beach(
    id: '22',
    name: 'Puri Beach',
    image: 'assets/puri.jpg',
    location: 'Odisha',
    waveHeight: 1.1,
    windSpeed: 12,
    description:
        'Puri Beach is a popular destination in Odisha, known for its cultural significance and golden sands. '
        'It is a hub for pilgrims visiting the Jagannath Temple and offers beautiful sunrise and sunset views. '
        'The beach is also famous for its annual Puri Beach Festival.',
    activities: ['Pilgrimage', 'Swimming', 'Sand Art', 'Cultural Events'],
  ),
];

class SuitabilityAlgorithm {
  static String evaluateWaterQuality(Map<String, dynamic> weatherData) {
    double waveHeight = weatherData['current']['wave_height'] ?? 0.0;
    double windSpeed = weatherData['current']['wind_speed'] ?? 0.0;

    if (waveHeight > 2.5 || windSpeed > 30) {
      return 'Poor';
    } else if (waveHeight > 1.5 || windSpeed > 20) {
      return 'Moderate';
    }
    return 'Good';
  }
}
