import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create user account
  Future<User?> signUpWithEmailAndPassword(
    String email,
    String password,
    String firstName,
    String lastName,
  ) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = credential.user;
      if (user != null) {
        await _addUserData(
          user.uid,
          email,
          firstName,
          lastName,
          null,
          null,
          "User",
        );
      }
      return user;
    } catch (e) {
      if (kDebugMode) {
        print("Some error occurred during sign-up: $e");
      }
      return null;
    }
  }

  // Create vendor account
  Future<User?> signUpVendor(
    String userName,
    String email,
    String password,
    String numeroCin,
    String companyName,
    String patentNumber,
  ) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = credential.user;
      if (user != null) {
        await _addVendorData(
          user.uid,
          userName,
          email,
          numeroCin,
          'vendor',
          companyName,
          patentNumber,
        );
      }
      return user;
    } catch (e) {
      if (kDebugMode) {
        print("Some error occurred during vendor sign-up: $e");
      }
      return null;
    }
  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = credential.user;
      if (user != null) {
        String? userType = await _getUserType(user.uid);
        if (userType == 'vendor') {
          return user;
        } else {
          // User is not a vendor, handle accordingly
          return null;
        }
      }
      return user;
    } catch (e) {
      if (kDebugMode) {
        print("Some error occurred during sign-in: $e");
      }
      return null;
    }
  }

  Future<String?> _getUserType(String userId) async {
    try {
      DocumentSnapshot snapshot = await _firestore.collection('users').doc(userId).get();
      if (snapshot.exists) {
        return snapshot.get('userType') as String?;
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print("Error retrieving user type: $e");
      }
      return null;
    }
  }

  Future<void> _addVendorData(
    String vendorId,
    String userName,
    String email,
    String numeroCin,
    String userType,
    String companyName,
    String patentNumber,
  ) async {
    try {
      await _firestore.collection('vendors').doc(vendorId).set({
        'userName': userName,
        'email': email,
        'numeroCin': numeroCin,
        'companyName': companyName,
        'patentNumber': patentNumber,
        'userType': userType,
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error occurred while adding vendor data: $e");
      }
    }
  }

  Future<void> _addUserData(String userId, String email, String firstName, String lastName,
      File? profileImage, List<File>? additionalFiles, String userType) async {
    try {
      // Create a reference to the user document
      DocumentReference userRef = _firestore.collection('users').doc(userId);

      // Create a reference to the Cloud Storage instance
      FirebaseStorage storage = FirebaseStorage.instance;

      // Create a map of the user data
      Map<String, dynamic> userData = {
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
      };

      // If a profile image is provided, upload it to Cloud Storage and add the download URL to the user data
      if (profileImage != null) {
        String imageName = '$userId-profile-image.jpg';
        String imageUrl = await _uploadFileToStorage(profileImage, 'user-profiles/$imageName', storage);
        userData['profileImageUrl'] = imageUrl;
      }

      // If additional files are provided, upload them to Cloud Storage and add the download URLs to the user data
      if (additionalFiles != null) {
        List<String> fileUrls = await Future.wait(additionalFiles.map((file) async {
          String fileName = '$userId-${additionalFiles.indexOf(file)}.${file.path.split('.').last}';
          return await _uploadFileToStorage(file, 'user-files/$fileName', storage);
        }));
        userData['additionalFileUrls'] = fileUrls;
      }

      // Set the user data, including the image URLs if provided
      await userRef.set(userData);
    } catch (e) {
      if (kDebugMode) {
        print("Error occurred while adding user data: $e");
      }
    }
  }

  Future<String> _uploadFileToStorage(File file, String path, FirebaseStorage storage) async {
    // Upload the file to Cloud Storage and return the download URL
    TaskSnapshot snapshot = await storage.ref(path).putFile(file);
    return await snapshot.ref.getDownloadURL();
  }

  Future<User?> signInVendor(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } catch (e) {
      if (kDebugMode) {
        print("Some error occurred during vendor sign-in: $e");
      }
      return null;
    }
  }
}
