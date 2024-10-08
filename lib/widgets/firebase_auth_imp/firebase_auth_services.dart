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
    String userName,
    String userType,
    int age,
    String maritalStatus,
    double salary,
    String employment,
    String imagePath,
  ) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = credential.user;
      if (user != null) {
        // Add user data to Firestore
        await _addUserData(
          user.uid,
          email,
          userName,
          userType,
          age,
          maritalStatus,
          salary,
          employment,
          imagePath,
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
    String imagePath,
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
          imagePath,
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
  Future<Map<String, dynamic>?> getUserType(String userId) async {
    try {
      DocumentSnapshot vendorSnapshot = await _firestore.collection('vendors').doc(userId).get();
      if (vendorSnapshot.exists && vendorSnapshot.data() != null) {
        var vendorData = vendorSnapshot.data() as Map<String, dynamic>;
        String folderPath = vendorData['folderPath'] as String;
        List<String> imageList = await _getImageListFromStorage(folderPath);
        return {
          'userType': vendorData['userType'],
          'imageList': imageList,
        };
      }

      DocumentSnapshot userSnapshot = await _firestore.collection('users').doc(userId).get();
      if (userSnapshot.exists && userSnapshot.data() != null) {
        var userData = userSnapshot.data() as Map<String, dynamic>;
        return {
          'userType': userData['userType'],
          'imageList': [],
        };
      } else {
        if (kDebugMode) {
          print("User document doesn't exist or data is null.");
        }
        return null;
      }
    } catch (e) {
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
    String imagePath,
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
        'imagePath': imagePath,
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
    String userName,
    String userType,
    int age,
    String maritalStatus,
    double salary,
    String employment,
    String imagePath,
  ) async {
    try {
      await _firestore.collection('users').doc(userId).set({
        'userId': userId,
        'email': email,
        'userName': userName,
        'userType': userType,
        'age': age,
        'maritalStatus': maritalStatus,
        'salary': salary,
        'employment': employment,
        'imagePath': imagePath,
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error adding user data to Firestore: $e");
      }
    }
  }

// Retrieve the image list from Firebase Storage
  Future<List<String>> _getImageListFromStorage(String folderPath) async {
    try {
      // Create a reference to the folder in Firebase Storage
      Reference storageRef = FirebaseStorage.instance.ref().child(folderPath);

      // Get the list of items in the folder
      ListResult listResult = await storageRef.listAll();

      // Extract the download URLs of the images
      List<String> imageList = [];
      for (var item in listResult.items) {
        String downloadURL = await item.getDownloadURL();
        imageList.add(downloadURL);
      }

      return imageList;
    } catch (e) {
      // Handle any errors that occur during image retrieval
      if (kDebugMode) {
        print("Error retrieving image list from storage: $e");
      }
      return [];
    }
  }

// Function to get image download URL from Firebase Storage
  Future<String?> getImageDownloadUrl(String imagePath) async {
    try {
      Reference ref = FirebaseStorage.instance.ref().child(imagePath);
      String downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      if (kDebugMode) {
        print("Error getting image download URL: $e");
      }
      return null;
    }
  }

  // Vendor-specific sign-in (could be expanded or modified as needed)
  Future<User?> signInVendor(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = credential.user;
      if (user != null) {
        String? userType = getUserType as String?;
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

  String getCurrentUserId() {
    // Récupérez l'ID de l'utilisateur connecté à partir de FirebaseAuth
    User? user = _auth.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      // Si aucun utilisateur n'est connecté, vous pouvez renvoyer null ou lever une erreur selon vos besoins
      throw Exception("No user currently signed in.");
    }
  }

  /// Method to fetch full user profile from Firestore
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
  }

  /// Method to fetch full vendor profile from Firestore

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

  // Function to check eligibility based on salary
  Future<String> checkEligibility(double salary, double itemPrice) async {
    try {
      String userId = _auth.currentUser?.uid ?? ""; // Get current user ID

      // Get user data from Firestore
      Map<String, dynamic>? userData = await fetchUserProfile(userId);

      // Check if user data is available
      if (userData != null) {
        String maritalStatus = userData['maritalStatus'];
        String jobClass = userData['employment'];

        // Check eligibility based on salary
        if (salary >= 3 * itemPrice) {
          return "Eligible";
        } else {
          // Calculate initial score
          int score = 0;

          // Check salary condition
          if (salary < 3 * itemPrice) {
            if (maritalStatus == "married") {
              score += 50;
            }
            // You need to define educational_level in your user data
            // and pass it here
            // if (educational_level == "higher") {
            //   score += 50;
            // }
            if (jobClass == "A") {
              score += 100;
            } else if (jobClass == "B") {
              score += 70;
            } else if (jobClass == "C") {
              score += 30;
            }
          }

          // Check overall score for eligibility
          if (score > 200) {
            return "Eligible";
          } else {
            return "Not Eligible";
          }
        }
      } else {
        return "Error: User data not found.";
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error checking eligibility: $e");
      }
      return "Error: An unexpected error occurred.";
    }
  }

  Future<bool> checkVendorEmailExists(String email) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('vendors')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      return snapshot.docs.isNotEmpty;
    } catch (e) {
      // Handle any potential errors here
      if (kDebugMode) {
        print('Error checking vendor EMAIL: $e');
      }
      return false;
    }
  }
}
