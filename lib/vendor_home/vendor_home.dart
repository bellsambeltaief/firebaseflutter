import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
  late Future<List<Map<String, dynamic>>> _imageData;

  @override
  void initState() {
    super.initState();
    _imageData = _fetchImages();
  }

  Future<List<Map<String, dynamic>>> _fetchImages() async {
    List<Map<String, dynamic>> images = [];
    var snapshot = await FirebaseFirestore.instance
        .collection('cheques')
        .where('vendorEmail', isEqualTo: widget.vendorEmail)
        .orderBy('uploadedAt', descending: true)
        .get();

    for (var doc in snapshot.docs) {
      images.add({
        'downloadUrl': doc.data()['downloadUrl'] as String,
        'fileName': doc.data()['fileName'] as String,
      });
    }

    return images;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vendor Images'),
        backgroundColor: Colors.blue[900],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _imageData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error fetching images: ${snapshot.error}'),
            );
          } else if (snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No images found'),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var imageData = snapshot.data![index];
                return ListTile(
                  leading: Image.network(
                    imageData['downloadUrl'] as String,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  title: Text(imageData['fileName'] as String),
                );
              },
            );
          }
        },
      ),
    );
  }
}
