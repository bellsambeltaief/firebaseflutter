import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ImageUploadPage extends StatefulWidget {
  @override
  _ImageUploadPageState createState() => _ImageUploadPageState();
}

class _ImageUploadPageState extends State<ImageUploadPage> {
  File? _image;
  final picker = ImagePicker();
  String uploadStatus = '';
  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        uploadStatus = ''; // Reset upload status message when a new image is selected
      }
    });
  }

  Future uploadImage() async {
    if (_image != null) {
      var user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        try {
          var snapshot = await FirebaseStorage.instance
              .ref(
                  'https://console.firebase.google.com/project/smart-1924e/storage/smart-1924e.appspot.com/files/~2Ffolders/${user.uid}/${DateTime.now().toIso8601String()}')
              .putFile(_image!);
          var downloadUrl = await snapshot.ref.getDownloadURL();
          print('Uploaded. URL: $downloadUrl');
          setState(() {
            uploadStatus = 'Image uploaded successfully! URL: $downloadUrl';
          });
        } catch (e) {
          print('Error uploading image: $e');
          setState(() {
            uploadStatus = 'Error uploading image: $e';
          });
        }
      } else {
        print('Error: No user logged in.');
        setState(() {
          uploadStatus = 'Error: No user logged in.';
        });
      }
    } else {
      print('Error: No image selected.');
      setState(() {
        uploadStatus = 'Error: No image selected.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Image'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: double.infinity,
                child: _image == null ? const Text('No image selected.') : Image.file(_image!),
              ),
              ElevatedButton(
                onPressed: getImage,
                child: const Text('Select Image'),
              ),
              ElevatedButton(
                onPressed: uploadImage,
                child: const Text('Upload Image'),
              ),
              if (uploadStatus.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(uploadStatus), // Display the upload status message
                )
            ],
          ),
        ),
      ),
    );
  }
}
