import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_tourism_app/Screens/home_screen.dart';
import 'package:travel_tourism_app/Screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Create fade-in animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward();

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);

    _checkUserAndNavigate();
  }

  _checkUserAndNavigate() async {
    await Future.delayed(const Duration(seconds: 3));

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                isLoggedIn ? const HomeScreen() : const LoginScreen()),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.blue.shade100, // Light blue background for coastal theme
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Decorated Image with Rounded Corners & Shadow
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), // Rounded corners
                  boxShadow: [
                    const BoxShadow(
                      color: Colors.black26, // Soft shadow effect
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(20), // Match border radius
                  child: Image.asset(
                    'assets/baga.jpg',
                    height: 150,
                    width: 150,
                    fit: BoxFit.cover, // Ensures full coverage
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Styled Text
              Text(
                'Coastal Tourism',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900, // Deep blue text for contrast
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
