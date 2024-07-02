// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:nexthack/screens/capturescreen.dart';
// import 'package:nexthack/screens/chatscreen.dart';
// import 'package:nexthack/screens/imagepickscreen.dart';
// import 'package:nexthack/screens/voicescreen.dart';

// class CameraScreen extends StatefulWidget {
//   const CameraScreen({super.key});

//   @override
//   State<CameraScreen> createState() => _CameraScreenState();
// }

// class _CameraScreenState extends State<CameraScreen> {
//   CameraController? _controller;
//   List<CameraDescription>? _cameras;
//   File? _image;
//   bool _isFlashOn = false;
//   int _selectedIndex = 2;
//   int _selectedCameraIndex = 0;

//   Future<void> _capture() async {
//     if (_controller == null || !_controller!.value.isInitialized) return;
//     try {
//       final camera = await _controller!.takePicture();
//       setState(() {
//         _controller!.setFlashMode(FlashMode.off);
//         _image = File(camera.path);
//       });
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => CaptureScreen(
//             imagePath: camera.path,
//             selected_index: _selectedCameraIndex,
//           ),
//         ),
//       );
//     } catch (e) {
//       // Handle exceptions here
//       print(e);
//     }
//   }

//   void _toggleIcon(int index) {
//     setState(() {
//       _selectedIndex = _selectedIndex == index ? -1 : index;
//     });
//   }

//   Future<void> _initializeCameras() async {
//     WidgetsFlutterBinding.ensureInitialized();
//     _cameras = await availableCameras();
//     if (_cameras != null && _cameras!.isNotEmpty) {
//       print('$_selectedCameraIndex');
//       _initializeController(_cameras![_selectedCameraIndex]);
//     }
//   }

//   Future<void> _initializeController(
//       CameraDescription cameraDescription) async {
//     _controller = CameraController(
//       cameraDescription,
//       ResolutionPreset.ultraHigh,
//       enableAudio: false,
//     );

//     try {
//       await _controller!.initialize();
//       if (!mounted) return;
//       setState(() {});
//     } catch (e) {
//       // Handle exceptions here
//       print(e);
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     _initializeCameras();
//   }

//   @override
//   void dispose() {
//     _controller?.dispose();
//     super.dispose();
//   }

//   void _toggleFlash() async {
//     if (_controller == null) return;
//     if (_isFlashOn) {
//       await _controller!.setFlashMode(FlashMode.off);
//     } else {
//       await _controller!.setFlashMode(FlashMode.torch);
//     }
//     setState(() {
//       _isFlashOn = !_isFlashOn;
//     });
//   }

//   void _switchCamera() {
//     if (_cameras == null || _cameras!.isEmpty) return;
//     _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras!.length;
//     _initializeController(_cameras![_selectedCameraIndex]);
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_controller == null || !_controller!.value.isInitialized) {
//       return Scaffold(
//         appBar: AppBar(
//           title: Text("NextHack"),
//         ),
//         body: Center(
//           child: CircularProgressIndicator(),
//         ),
//       );
//     }
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("NextHack"),
//         actions: <Widget>[
//           IconButton(
//             icon: Icon(
//               _isFlashOn ? Icons.flash_on : Icons.flash_off,
//               color: _isFlashOn ? Colors.yellow : Colors.grey,
//             ),
//             onPressed: _toggleFlash,
//           ),
//           IconButton(
//             icon: Icon(Icons.cameraswitch),
//             onPressed: _switchCamera,
//           ),
//           IconButton(
//               onPressed: () {
//                 Navigator.push(context,
//                     MaterialPageRoute(builder: (context) => ImagePickScreen()));
//               },
//               icon: Icon(Icons.attach_file))
//         ],
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           Expanded(
//             child: Center(
//               child: _image != null
//                   ? Image.file(_image!)
//                   : CameraPreview(_controller!),
//             ),
//           ),
//           SizedBox(height: 20.0),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               IconButton(
//                 onPressed: _capture,
//                 icon: Icon(Icons.camera_rounded),
//                 color: Colors.grey[500],
//               )
//             ],
//           ),
//         ],
//       ),
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.all(0),
//         child: Container(
//           padding: EdgeInsets.symmetric(vertical: 8.0),
//           decoration: BoxDecoration(
//             color: Colors.grey[200], // Background color of the container
//             borderRadius: BorderRadius.circular(10), // Rounded corners
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: <Widget>[
//               ToggleIconButton(
//                 icon: Icons.mic_outlined,
//                 isSelected: _selectedIndex == 0,
//                 onPressed: () {
//                   _toggleIcon(0);
//                   Navigator.push(context,
//                       MaterialPageRoute(builder: (context) => VoiceScreen()));
//                 },
//               ),
//               ToggleIconButton(
//                 icon: Icons.keyboard_outlined,
//                 isSelected: _selectedIndex == 1,
//                 onPressed: () {
//                   _toggleIcon(1);
//                   Navigator.push(context,
//                       MaterialPageRoute(builder: (context) => chatscreen()));
//                 },
//               ),
//               ToggleIconButton(
//                 icon: Icons.camera_alt_outlined,
//                 isSelected: _selectedIndex == 2,
//                 onPressed: () {
//                   _toggleIcon(2);
//                   Navigator.push(context,
//                       MaterialPageRoute(builder: (context) => CameraScreen()));
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class ToggleIconButton extends StatelessWidget {
//   final IconData icon;
//   final bool isSelected;
//   final VoidCallback onPressed;

//   ToggleIconButton({
//     required this.icon,
//     required this.isSelected,
//     required this.onPressed,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return IconButton(
//       icon: Icon(icon),
//       color: isSelected ? Colors.deepPurple : Colors.grey,
//       onPressed: onPressed,
//       iconSize: 36,
//     );
//   }
// }
