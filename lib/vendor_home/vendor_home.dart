import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smart/common/button.dart';
import 'package:smart/widgets/authentification/log_in/vendor_log_in_firebase.dart';
import 'package:smart/widgets/firebase_auth_imp/firebase_auth_services.dart';

class VendorHome extends StatefulWidget {
  const VendorHome({Key? key}) : super(key: key);

  @override
  State<VendorHome> createState() => _VendorHomeState();
}

class _VendorHomeState extends State<VendorHome> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  @override
  Widget build(BuildContext context) {
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
                      'You can find all the client folders here',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Button(
                      label: "Log Out",
                      onTap: () async {
                        try {
                          await _auth.logOut();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const VendorLogFirebase(),
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
