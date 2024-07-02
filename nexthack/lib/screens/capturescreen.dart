// import 'package:flutter/material.dart';
// import 'dart:io';

// import 'package:nexthack/screens/camerascreen.dart';
// import 'package:nexthack/screens/descriptionscreen.dart';

// class CaptureScreen extends StatelessWidget {
//   final String imagePath;
//   final int selected_index;

//   const CaptureScreen(
//       {super.key, required this.imagePath, required this.selected_index});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Capture'),
//         leading: Builder(
//           builder: (BuildContext context) {
//             return IconButton(
//               icon: const Icon(Icons.keyboard_arrow_left),
//               onPressed: () {
//                 Navigator.push(context,
//                     MaterialPageRoute(builder: (context) => CameraScreen()));
//               },
//               tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
//             );
//           },
//         ),
//       ),
//       body: Transform.flip(
//         flipX: selected_index == 0 ? false : true,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Expanded(
//               child: Image.file(File(imagePath)),
//             ),
//             SizedBox(
//               height: 10,
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.all(0),
//         child: Container(
//           padding: EdgeInsets.symmetric(vertical: 10.0),
//           decoration: BoxDecoration(
//             color: Colors.grey[200], // Background color of the container
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) =>
//                               CameraScreen())); // Navigate back to CameraScreen
//                 },
//                 child: Row(
//                   children: [
//                     Icon(Icons.restart_alt),
//                     Text('Recapture'),
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 width: 35,
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => DescriptionScreen(
//                                 imagePath: imagePath,
//                               )));
//                 },
//                 child: Row(
//                   children: [
//                     Text('Send'),
//                     Icon(Icons.keyboard_arrow_right_sharp),
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
