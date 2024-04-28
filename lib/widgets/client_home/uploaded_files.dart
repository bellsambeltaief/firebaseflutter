import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class UploadedFiles extends StatelessWidget {
  final List<File> uploadedFileNames;

  const UploadedFiles({required this.uploadedFileNames});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Uploaded Files'),
      ),
      body: ListView.builder(
        itemCount: uploadedFileNames.length,
        itemBuilder: (context, index) {
          final fileName = uploadedFileNames[index];
          final storageRef = firebase_storage.FirebaseStorage.instance.ref('uploads/$fileName');

          return FutureBuilder(
            future: storageRef.getDownloadURL(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return ListTile(
                  title: Text('File $index'),
                  leading: const CircularProgressIndicator(),
                );
              }

              if (snapshot.hasError) {
                return ListTile(
                  title: Text('File $index'),
                  leading: const Icon(Icons.error),
                );
              }

              final fileUrl = snapshot.data as String;

              return ListTile(
                leading: Image.network(fileUrl),
                title: Text('File $index'),
              );
            },
          );
        },
      ),
    );
  }
}
