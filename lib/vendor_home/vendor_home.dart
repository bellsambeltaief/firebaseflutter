import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class VendorFilesWidget extends StatefulWidget {
  final String vendorEmail;

  const VendorFilesWidget({super.key, required this.vendorEmail});

  @override
  _VendorFilesWidgetState createState() => _VendorFilesWidgetState();
}

class _VendorFilesWidgetState extends State<VendorFilesWidget> {
  List<String> fileNames = [];

  @override
  void initState() {
    super.initState();
    _getVendorFiles();
  }

  Future<void> _getVendorFiles() async {
    try {
      final storageRef =
          firebase_storage.FirebaseStorage.instance.ref('vendors/${widget.vendorEmail}/cheques');
      final ListResult result = await storageRef.listAll();

      setState(() {
        fileNames = result.items.map((ref) => ref.name).toList();
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error retrieving vendor files: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Vendor Files'),
        ),
        body: ListView.builder(
          itemCount: fileNames.length,
          itemBuilder: (context, index) {
            final fileName = fileNames[index];
            final storageRef = firebase_storage.FirebaseStorage.instance
                .ref('vendors/${widget.vendorEmail}/cheques/$fileName');

            return FutureBuilder(
              future: storageRef.getDownloadURL(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return ListTile(
                    title: Text(fileName),
                    leading: const CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return ListTile(
                    title: Text(fileName),
                    leading: const Icon(Icons.error),
                  );
                }

                final imageUrl = snapshot.data as String;

                return ListTile(
                  leading: Image.network(imageUrl),
                  title: Text(fileName),
                );
              },
            );
          },
        ));
  }
}
