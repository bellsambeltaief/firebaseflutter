import 'package:firebase_auth/firebase_auth.dart';
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
        setState(() {
          firstName = userDetails['firstName'] ?? '';
          lastName = userDetails['lastName'] ?? '';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;
    String userId = currentUser?.uid ?? ''; // Obtain the user ID
    FirebaseAuthService authService = FirebaseAuthService();
    Color blue800 = Colors.blue[800] ?? Colors.blue;
    Color blue300 = Colors.blue[300] ?? Colors.lightBlue;

    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [blue800, blue300],
                  stops: const [0.2, 1],
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'Welcome',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
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
          ],
        ),
      ),
    );
  }
}
