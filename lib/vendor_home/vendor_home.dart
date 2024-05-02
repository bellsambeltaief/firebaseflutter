import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smart/common/button.dart';
import 'package:smart/widgets/authentification/log_in/vendor_log_in_firebase.dart';
import 'package:smart/widgets/firebase_auth_imp/firebase_auth_services.dart';

class VendorHome extends StatefulWidget {
  final String vendorEmail;

  const VendorHome({
    Key? key,
    required this.vendorEmail,
  }) : super(key: key);

  @override
  State<VendorHome> createState() => _VendorHomeState();
}

class _VendorHomeState extends State<VendorHome> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cheques List'),
        backgroundColor: Colors.blue[900],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 10.0,
        ),
        child: Column(
          children: [
            FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection('cheques')
                  .where('vendorEmail', isEqualTo: widget.vendorEmail)
                  .get(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Text('No cheques found for this vendor');
                }

                // Extract the list of documents from the snapshot
                final documents = snapshot.data!.docs;

                return Expanded(
                  child: ListView.builder(
                    itemCount: documents.length,
                    itemBuilder: (BuildContext context, int index) {
                      String imageUrl = documents[index].get('downloadUrl');
                      return ListTile(
                        leading: Image.network(
                          imageUrl,
                          width: 80,
                          height: 80,
                        ),
                        title: Text(
                          'Cheque ${index + 1}',
                          style: TextStyle(
                            color: Colors.blue[900],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          'Client: ${documents[index].get('userEmail')}',
                        ),
                      );
                    },
                  ),
                );
              },
            ),
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
    );
  }
}
