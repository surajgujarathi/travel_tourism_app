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
        MaterialPageRoute(
            builder: (context) => const ReviewsAndWishListScreen()),
      );
    } else if (index == 2) {
      // Go to ProfileScreen or LoginScreen if logged out
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfileScreen()),
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
            expandedHeight: 88.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 16, bottom: 10),
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
            // actions: [
            //   PopupMenuButton<String>(
            //     icon: const Icon(Icons.account_circle,
            //         size: 30, color: Colors.white),
            //     onSelected: (value) async {
            //       if (value == 'wishlist') {
            //         Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //               builder: (context) => const WishlistScreen()),
            //         );
            //       } else if (value == 'logout') {
            //         // Sign out the user
            //         await FirebaseAuth.instance.signOut();
            //         SharedPreferences prefs =
            //             await SharedPreferences.getInstance();
            //         prefs.clear();

            //         // Navigate to the login screen after logout
            //         Navigator.pushReplacement(
            //           context,
            //           MaterialPageRoute(
            //               builder: (context) => const LoginScreen()),
            //         );
            //       }
            //     },
            //     itemBuilder: (context) => [
            //       const PopupMenuItem(
            //         value: 'wishlist',
            //         child: ListTile(
            //           leading: Icon(Icons.favorite, color: Colors.red),
            //           title: Text('Wishlist'),
            //         ),
            //       ),
            //       const PopupMenuItem(
            //         value: 'logout',
            //         child: ListTile(
            //           leading: Icon(Icons.logout, color: Colors.red),
            //           title: Text('Logout'),
            //         ),
            //       ),
            //     ],
            //   ),
            // ],
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
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Explore',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade800,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildCategoryItem(
                          context, 'Honeymoon', 'assets/couple.jpg.avif'),
                      _buildCategoryItem(
                          context, 'Solo', 'assets/tourist-icon-0.jpg.png'),
                      _buildCategoryItem(
                          context, 'Family', 'assets/family.jpg.avif'),
                    ],
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
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(
      BuildContext context, String label, String imagePath) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryBeachesScreen(category: label),
          ),
        );
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 33,
            backgroundImage: AssetImage(imagePath),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class CategoryBeachesScreen extends StatelessWidget {
  final String category;

  const CategoryBeachesScreen({Key? key, required this.category})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Filter beaches based on the category
    List<Beach> categoryBeaches =
        beaches.where((beach) => beach.category == category).toList();

    return Scaffold(
      appBar: AppBar(title: Text('$category Beaches')),
      body: ListView.builder(
        itemCount: categoryBeaches.length,
        itemBuilder: (context, index) {
          final beach = categoryBeaches[index];
          return BeachCard(
            beach: beach,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BeachDetailsScreen(beach: beach),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool pushNotifications = true;
  bool faceId = true;
  int selectedIndex = 2; // Profile tab selected

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                // Profile Avatar
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.transparent,
                      backgroundImage:
                          AssetImage('assets/tourist-icon-0.jpg.png'),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Beachstories',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'mark.brook@icloud.com',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                // Edit Profile Button
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Edit profile',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 24),
                // Inventories Section
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Inventories',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => WishlistScreen()));
                  },
                  child: _buildListTile(
                    'My Wishlist',
                    Icons.store,
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        '2',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                _buildListTile('Support', Icons.help_outline),
                const SizedBox(height: 24),
                // Preferences Section
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Preferences',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                _buildSwitchTile(
                  'Push notifications',
                  Icons.notifications_none,
                  pushNotifications,
                  (value) => setState(() => pushNotifications = value),
                ),
                _buildSwitchTile(
                  'Face ID',
                  Icons.face,
                  faceId,
                  (value) => setState(() => faceId = value),
                ),
                _buildListTile('PIN Code', Icons.lock_outline),
                const SizedBox(height: 16),
                // Logout Button
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.clear();

                    // Navigate to the login screen after logout
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                    );
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildListTile(String title, IconData icon, {Widget? trailing}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.white,
          activeTrackColor: Colors.green,
        ),
      ),
    );
  }
}
