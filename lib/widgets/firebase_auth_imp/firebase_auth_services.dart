import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:smart/widgets/firebase_auth_imp/folder.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create user account
  Future<User?> signUpWithEmailAndPassword(
    String email,
    String password,
    String firstName,
    String lastName,
    String userType,
    int age,
    String maritalStatus,
    double salary,
    String employment,
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
          userType,
          age,
          maritalStatus,
          salary,
          employment,
        );
      }
      return user;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print("Firebase Auth Error during sign-up: ${e.message}");
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
    String userType,
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
          userType,
          companyName,
          patentNumber,
        );
      }
      return user;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print("Firebase Auth Error during vendor sign-up: ${e.message}");
      }
      return null;
    }
  }

  // Generic sign-in method for users
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print("Firebase Auth Error during sign-in: ${e.message}");
      }
      return null;
    }
  }

// Get user type from Firestore
  Future<String?> getUserType(String userId) async {
    try {
      // Check if the user is a vendor
      DocumentSnapshot vendorSnapshot = await _firestore.collection('vendors').doc(userId).get();
      if (vendorSnapshot.exists && vendorSnapshot.data() != null) {
        var vendorData = vendorSnapshot.data() as Map<String, dynamic>;
        return vendorData['userType'] as String?;
      }

      // If the user is not a vendor, check if they are a regular user
      DocumentSnapshot userSnapshot = await _firestore.collection('users').doc(userId).get();
      if (userSnapshot.exists && userSnapshot.data() != null) {
        var userData = userSnapshot.data() as Map<String, dynamic>;
        return userData['userType'] as String?;
      } else {
        // Handle the case where the document doesn't exist or data is null
        if (kDebugMode) {
          print("User document doesn't exist or data is null.");
        }
        return null;
      }
    } catch (e) {
      // Handle any other errors
      if (kDebugMode) {
        print("Error retrieving user type: $e");
      }
      return null;
    }
  }

  // Add vendor data to Firestore
  Future<void> _addVendorData(
    String userId,
    String userName,
    String email,
    String numeroCin,
    String userType,
    String companyName,
    String patentNumber,
  ) async {
    try {
      await _firestore.collection('vendors').doc(userId).set({
        'userId': userId,
        'userName': userName,
        'email': email,
        'numeroCin': numeroCin,
        'companyName': companyName,
        'patentNumber': patentNumber,
        'userType': userType,
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error adding vendor data to Firestore: $e");
      }
    }
  }

  /// Add the user data
  Future<void> _addUserData(
    String userId,
    String email,
    String firstName,
    String lastName,
    String userType,
    int age,
    String maritalStatus,
    double salary,
    String employment,
  ) async {
    try {
      await _firestore.collection('users').doc(userId).set({
        'userId': userId,
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'userType': userType,
        'age': age,
        'maritalStatus': maritalStatus,
        'salary': salary,
        'employment': employment,
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error adding user data to Firestore: $e");
      }
    }
  }

  // Vendor-specific sign-in (could be expanded or modified as needed)
  Future<User?> signInVendor(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = credential.user;
      if (user != null) {
        String? userType = await getUserType(user.uid);
        if (userType == 'vendor') {
          return user;
        }
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print("Error during vendor sign-in: $e");
      }
      return null;
    }
  }

  // Method to log out the user
  Future<void> logOut() async {
    try {
      await _auth.signOut();
      if (kDebugMode) {
        print("User has been logged out successfully.");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error logging out: $e");
      }
      throw FirebaseAuthException(code: 'LOGOUT_FAILED', message: 'Failed to log out.');
    }
  }

  // Method to fetch full user profile from Firestore
  Future<Map<String, dynamic>?> fetchUserProfile(String userId) async {
    try {
      DocumentSnapshot snapshot = await _firestore.collection('users').doc(userId).get();
      if (snapshot.exists && snapshot.data() != null) {
        return snapshot.data() as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print("Error retrieving user profile: $e");
      }
      return null;
    }
  } // Method to fetch full vendor profile from Firestore

  Future<Map<String, dynamic>?> fetchVendorProfile(String userId) async {
    try {
      DocumentSnapshot snapshot = await _firestore.collection('vendors').doc(userId).get();
      if (snapshot.exists && snapshot.data() != null) {
        return snapshot.data() as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print("Error retrieving vendor profile: $e");
      }
      return null;
    }
  }

  // Function to upload folder to Firebase Storage and save metadata to Firestore
  Future<void> uploadFolder(String folderName, List<File> files, String userId) async {
    try {
      List<String> fileUrls = [];

      // Upload each file in the folder to Firebase Storage
      for (File file in files) {
        final ref = FirebaseStorage.instance.ref().child('$folderName/${file.path.split('/').last}');
        await ref.putFile(file);
        final downloadUrl = await ref.getDownloadURL();
        fileUrls.add(downloadUrl);
      }

      // Save folder details to Firestore, including user ID and file URLs
      await FirebaseFirestore.instance
          .collection('folders')
          .doc(userId)
          .collection('user_folders')
          .doc(folderName)
          .set({
        'name': folderName,
        'fileUrls': fileUrls,
        'userId': userId,
      });
    } catch (e) {
      print('Error uploading folder: $e');
      throw e;
    }
  }

// Function to retrieve folders from Firestore based on user ID
  Future<List<Folder>> getUserFolders(String userId) async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('folders').doc(userId).collection('user_folders').get();
      final folders = snapshot.docs.map((doc) {
        final data = doc.data();
        return Folder(name: data['name'], fileUrls: List<String>.from(data['fileUrls']));
      }).toList();
      return folders;
    } catch (e) {
      print('Error retrieving user folders: $e');
      throw e;
    }
  }
}
