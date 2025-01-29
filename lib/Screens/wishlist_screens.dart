// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:travel_tourism_app/Screens/beach_details_screen.dart';
// import 'package:travel_tourism_app/demo.dart';

// class WishlistScreen extends StatefulWidget {
//   const WishlistScreen({Key? key}) : super(key: key);

//   @override
//   State<WishlistScreen> createState() => _WishlistScreenState();
// }

// class _WishlistScreenState extends State<WishlistScreen> {
//   List<Beach> wishlistBeaches = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadWishlist();
//   }

//   Future<void> _loadWishlist() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       wishlistBeaches = beaches.where((beach) {
//         return prefs.getBool('favorite_${beach.id}') ?? false;
//       }).toList();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.blueAccent,
//         title: const Text('My Wishlist'),
//       ),
//       body: wishlistBeaches.isEmpty
//           ? const Center(
//               child: Text('Your wishlist is empty'),
//             )
//           : ListView.builder(
//               itemCount: wishlistBeaches.length,
//               itemBuilder: (context, index) {
//                 return BeachCard(
//                   beach: wishlistBeaches[index],
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) =>
//                             BeachDetailsScreen(beach: wishlistBeaches[index]),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//     );
//   }
// }
