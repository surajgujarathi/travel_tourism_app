import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart'; // Import geolocator
import 'package:geocoding/geocoding.dart'; // Import geocoding for reverse geocoding
import 'package:travel_tourism_app/Screens/beach_details_screen.dart';
import 'package:travel_tourism_app/Screens/login_screen.dart';
import 'package:travel_tourism_app/demo.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Beach> filteredBeaches = List.from(beaches);
  int _selectedIndex = 0;
  String _location =
      'Fetching location...'; // Default text while location is loading
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Navigate to corresponding screens based on selected index
    if (index == 0) {
      // Go to HomeScreen
    } else if (index == 1) {
      // Go to WishlistScreen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const WishlistScreen()),
      );
    } else if (index == 2) {
      // Go to ProfileScreen or LoginScreen if logged out
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WishlistScreen()),
      );
    }
  }

  void _filterBeaches(String query) {
    setState(() {
      filteredBeaches = beaches
          .where((beach) =>
              beach.name.toLowerCase().contains(query.toLowerCase()) ||
              beach.location.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  // Get current location and reverse geocode it
  Future<void> _getCurrentLocation() async {
    // Request location permission
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      // Get the current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Reverse geocode to get human-readable address
      List<Placemark> placemarks =
          await GeocodingPlatform.instance!.placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      setState(() {
        // Update the location with the address from reverse geocoding
        _location = "${placemarks[0].locality}, ${placemarks[0].country}";
      });
    } else {
      setState(() {
        _location = "Location permission denied";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation(); // Fetch location on screen load
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.blueAccent,
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
              title: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          color: Colors.white, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        _location, // Display fetched or static location
                        style:
                            const TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Indian Coastal Tourism',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              background: Image.asset(
                'assets/radanagar.jpg',
                fit: BoxFit.cover,
              ),
            ),
            actions: [
              PopupMenuButton<String>(
                icon: const Icon(Icons.account_circle,
                    size: 30, color: Colors.white),
                onSelected: (value) async {
                  if (value == 'wishlist') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const WishlistScreen()),
                    );
                  } else if (value == 'logout') {
                    // Sign out the user
                    await FirebaseAuth.instance.signOut();
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.clear();

                    // Navigate to the login screen after logout
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'wishlist',
                    child: ListTile(
                      leading: Icon(Icons.favorite, color: Colors.red),
                      title: Text('Wishlist'),
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'logout',
                    child: ListTile(
                      leading: Icon(Icons.logout, color: Colors.red),
                      title: Text('Logout'),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Discover Safe and Beautiful Beaches',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade800,
                        ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search beaches...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                    ),
                    onChanged: _filterBeaches,
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final beach = filteredBeaches[index];
                return BeachCard(
                  beach: beach,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BeachDetailsScreen(
                          beach: beach,
                        ),
                      ),
                    );
                  },
                );
              },
              childCount: filteredBeaches.length,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
