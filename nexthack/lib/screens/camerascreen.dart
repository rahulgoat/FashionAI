import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import 'package:nexthack/screens/chatscreen.dart';
import 'package:nexthack/screens/voicescreen.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  int selectedIndex = 2;

  void toggleicon(int index) {
    setState(() {
      selectedIndex = selectedIndex == index ? -1 : index;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("NextHack"),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(0),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          decoration: BoxDecoration(
            color: Colors.grey[200], // Background color of the container
            borderRadius: BorderRadius.circular(10), // Rounded corners
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ToggleIconButton(
                  icon: Icons.mic_outlined,
                  isSelected: selectedIndex == 0,
                  onPressed: () {
                    toggleicon(0);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => VoiceScreen()));
                  }),
              SizedBox(width: 10),
              ToggleIconButton(
                  icon: Icons.keyboard_outlined,
                  isSelected: selectedIndex == 1,
                  onPressed: () {
                    toggleicon(1);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => chatscreen()));
                  }),
              SizedBox(width: 10),
              ToggleIconButton(
                  icon: Icons.camera_alt_outlined,
                  isSelected: selectedIndex == 2,
                  onPressed: () {
                    toggleicon(2);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CameraScreen()));
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

class ToggleIconButton extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback onPressed;

  ToggleIconButton({
    required this.icon,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon),
      color: isSelected ? Colors.deepPurple : Colors.grey,
      onPressed: onPressed,
      iconSize: 36,
    );
  }
}

class Message {
  final String content;
  final bool isUser;

  Message({required this.content, required this.isUser});
}
