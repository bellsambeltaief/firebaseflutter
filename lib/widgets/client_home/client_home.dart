import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smart/common/button.dart';
import 'package:smart/widgets/authentification/log_in/user_log_in_firebase.dart';
import 'package:smart/widgets/client_home/balance_card.dart';
import 'package:smart/widgets/client_home/purchase_button.dart';
import 'package:smart/widgets/client_home/user_details.dart';
import 'package:smart/widgets/firebase_auth_imp/firebase_auth_services.dart';

class ClientHome extends StatefulWidget {
  const ClientHome({Key? key}) : super(key: key);

  @override
  State<ClientHome> createState() => _ClientHomeState();
}

class _ClientHomeState extends State<ClientHome> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  String firstName = '';
  String lastName = '';

  final storage = FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();

    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      Map<String, dynamic>? userDetails = await _auth.fetchUserProfile(currentUser.uid);
      if (userDetails != null) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;
    String userId = currentUser?.uid ?? ''; // Obtain the user ID
    FirebaseAuthService authService = FirebaseAuthService();

    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: Container(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Welcome',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                  ),
                ),
                const SizedBox(height: 40),
                const BalanceCard(),
                const SizedBox(height: 20),
                UserDetails(
                  userId: userId,
                  authService: authService,
                ),
                const PurchaseButton(),
                const SizedBox(height: 20),
                Button(
                  label: "Log Out",
                  onTap: () async {
                    try {
                      await _auth.logOut();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const UserLogFirebase(),
                        ),
                      );
                    } catch (e) {
                      if (kDebugMode) {
                        print("Logout failed: $e");
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
