import 'package:flutter/material.dart';
import 'package:nexthack/screens/genderscreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/genderpage.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Adjust according to your design
                        Image.asset(
                          'assets/logo.png', // Replace with your logo asset
                          width: 40,
                          height: 40,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'SonicStyles',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontFamily: 'Agrandir-Regular'),
                        ),
                      ],
                    ),
                  ],
                ),
                const Column(
                  children: [
                    Text(
                      'Unleash the power of real sonic',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Agrandir-Regular'),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'AI powered Sonic for personalized fashion',
                      style: TextStyle(
                          color: Colors.white54,
                          fontSize: 14,
                          fontFamily: 'Agrandir-Grandlight'),
                    ),
                  ],
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Navigate to the next screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const GenderScreen(), // Replace with your target screen
                          ),
                        );
                      },
                      child: AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _animation.value,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const RadialGradient(
                                  colors: [Colors.purple, Colors.transparent],
                                  stops: [0.5, 1],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.purple.withOpacity(0.5),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.black,
                                child: Image.asset(
                                  'assets/purple.png',
                                  width: 80,
                                  height: 80,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      'Tap to start the Sonic ✨',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Agrandir-Regular'),
                    ),
                    const SizedBox(height: 20),
                    // Text(
                    //   '©2030 FashionGenie. All rights reserved.',
                    //   style: TextStyle(
                    //     color: Colors.white54,
                    //     fontSize: 12,
                    //   ),
                    // ),
                    // SizedBox(height: 20), // Adjust spacing as needed
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
