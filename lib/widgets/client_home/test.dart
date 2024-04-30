// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';

// class UserProfile extends StatelessWidget {
//   final User user;
//   final FirebaseFirestore firestore = FirebaseFirestore.instance;
//   final FirebaseStorage storage = FirebaseStorage.instance;

//   UserProfile(
//     this.user,
//   );

//   Future<String?> _getUserImagePath() async {
//     try {
//       DocumentSnapshot userSnapshot = await firestore.collection('users').doc(user.uid).get();
//       if (userSnapshot.exists && userSnapshot.data() != null) {
//         var userData = userSnapshot.data() as Map<String, dynamic>;
//         String? imagePath = userData['imagePath'] as String?;
//         return imagePath;
//       } else {
//         return null;
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print("Error retrieving user image path: $e");
//       }
//       return null;
//     }
//   }

//   Future<ImageProvider?> _getUserImage() async {
//     String? imagePath = await _getUserImagePath();
//     if (imagePath != null) {
//       try {
//         Reference ref = storage.ref().child(imagePath);
//         String imageUrl = await ref.getDownloadURL();
//         return NetworkImage(imageUrl);
//       } catch (e) {
//         if (kDebugMode) {
//           print("Error retrieving user image: $e");
//         }
//         return null;
//       }
//     } else {
//       return null;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<ImageProvider?>(
//       future: _getUserImage(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const CircularProgressIndicator();
//         } else if (snapshot.hasError) {
//           return const Text('Error loading user image');
//         } else {
//           ImageProvider? imageProvider = snapshot.data;
//           if (imageProvider != null) {
//             return CircleAvatar(
//               backgroundImage: imageProvider,
//               radius: 50,
//             );
//           } else {
//             return const CircleAvatar(
//               radius: 50,
//               child: Icon(Icons.person),
//             );
//           }
//         }
//       },
//     );
//   }
// }
