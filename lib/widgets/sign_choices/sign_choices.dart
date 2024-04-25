import 'package:flutter/material.dart';
import 'package:smart/common/button.dart';
import 'package:smart/widgets/authentification/log_in/user_log_in_firebase.dart';
import 'package:smart/widgets/authentification/log_in/vendor_log_in_firebase.dart';

class SignChoices extends StatelessWidget {
  const SignChoices({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: const Center(
            child: Text('Connect to Smart'),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Image.asset(
                  'assets/a.png',
                  width: 300,
                  height: 120,
                  color: Colors.blue[900],
                ),
              ),
              const SizedBox(height: 40),
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  "If you are a VENDOR, you have to press on Sign In as a Vendor.",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Button(
                label: 'Sign In as a Vendor',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const VendorLogFirebase(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  "If you are a CLIENT, you have to press on sign In as a Client",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Button(
                label: "Sign In as a Client",
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const UserLogFirebase(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
