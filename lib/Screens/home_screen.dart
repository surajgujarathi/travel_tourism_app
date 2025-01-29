import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  String _username = '';

  void _filterBeaches(String query) {
    setState(() {
      filteredBeaches = beaches
          .where((beach) =>
              beach.name.toLowerCase().contains(query.toLowerCase()) ||
              beach.location.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  // // Load the username from SharedPreferences
  // _loadUsername() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     _username = prefs.getString('username') ??
  //         'Guest'; // Default to 'Guest' if not found
  //   });
  // }

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   _loadUsername();
  // }

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
              title: const Text(
                'Indian Coastal Tourism',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              background: Image.asset(
                'assets/radanagar.jpg',
                fit: BoxFit.cover,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const WishlistScreen()),
                  );
                },
              ),
              IconButton(
                onPressed: () async {
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
                },
                icon: Icon(Icons.logout),
                color: Colors.red, // Optional: Customize the icon color
              )
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
    );
  }
}
