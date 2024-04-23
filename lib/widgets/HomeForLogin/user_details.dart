import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smart/widgets/HomeForLogin/user_info_card.dart';
import 'package:smart/widgets/firebase_auth_imp/firebase_auth_services.dart'; // Import your FirebaseAuthService

class UserDetails extends StatefulWidget {
  final String userId;
  final FirebaseAuthService authService;

  const UserDetails({
    Key? key,
    required this.userId,
    required this.authService,
  }) : super(key: key);

  @override
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      Map<String, dynamic>? userDetails = await widget.authService.fetchUserProfile(widget.userId);
      if (userDetails != null) {
        setState(() {
          _userData = userDetails;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading user data: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _userData != null
        ? _buildUserDetails(_userData!)
        : const Center(
            child: CircularProgressIndicator(),
          );
  }

  Widget _buildUserDetails(Map<String, dynamic> userData) {
    String fullName = '${userData['firstName'] ?? ''} ${userData['lastName'] ?? ''}';

    return Column(
      children: <Widget>[
        Text(
          fullName.trim(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        UserInfoCard(
          title: 'Salary',
          value: userData['salary'] != null ? userData['salary'].toString() : 'N/A',
          icon: Icons.monetization_on,
        ),
        UserInfoCard(
          title: 'Age',
          value: userData['age'] != null ? userData['age'].toString() : 'N/A',
          icon: Icons.cake,
        ),
        UserInfoCard(
          title: 'Marital Status',
          value: userData['maritalStatus'] ?? 'N/A',
          icon: Icons.favorite,
        ),
        UserInfoCard(
          title: 'Employment',
          value: userData['employment'] != null ? userData['employment'].toString() : 'N/A',
          icon: Icons.work,
        ),
      ],
    );
  }
}
