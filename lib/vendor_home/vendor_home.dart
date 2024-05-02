import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
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

  Future<String> _downloadImage(String imageUrl) async {
    final dio = Dio();
    final directory = await getTemporaryDirectory();
    final savePath = '${directory.path}/cheque_image.jpg';

    try {
      await dio.download(imageUrl, savePath);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Image downloaded successfully'),
        ),
      );
      return savePath;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to download the image'),
        ),
      );
      return '';
    }
  }

  Future<bool> _saveImageToGallery(String imagePath) async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      try {
        final result = await ImageGallerySaver.saveFile(imagePath);
        return result['isSuccess'];
      } catch (e) {
        if (kDebugMode) {
          print('Failed to save image to gallery: $e');
        }
        return false;
      }
    } else {
      if (kDebugMode) {
        print('Permission denied');
      }
      return false;
    }
  }

  void _showImageDialog(String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.9,
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
              ),
            ),
          ),
        );
      },
    );
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
                        leading: Stack(children: [
                          Image.network(
                            imageUrl,
                            width: 80,
                            height: 80,
                          ),
                          IconButton(
                            icon: const Icon(Icons.file_download),
                            onPressed: () async {
                              String filePath = await _downloadImage(imageUrl);
                              if (filePath.isNotEmpty) {
                                bool success = await _saveImageToGallery(filePath);
                                if (success) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Image saved to gallery'),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Failed to save image to gallery'),
                                    ),
                                  );
                                }
                              }
                            },
                          ),
                        ]),
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
                        onTap: () {
                          _showImageDialog(imageUrl);
                        },
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
