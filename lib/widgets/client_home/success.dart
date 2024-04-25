import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smart/common/button.dart';
import 'package:smart/widgets/authentification/log_in/user_log_in_firebase.dart';
import 'package:smart/widgets/firebase_auth_imp/firebase_auth_services.dart';

class Success extends StatefulWidget {
  const Success({super.key});

  @override
  State<Success> createState() => _SuccessState();
}

class _SuccessState extends State<Success> {
  final FirebaseAuthService _auth = FirebaseAuthService();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: const Center(
            child: Text('Upload Successful'),
          ),
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Uploading successfully'),
              const SizedBox(height: 50),
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
    );
  }
}
