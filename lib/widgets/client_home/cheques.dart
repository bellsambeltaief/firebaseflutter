import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smart/common/button.dart';
import 'package:smart/common/text_field.dart';
import 'package:smart/widgets/client_home/client_home.dart';
import 'package:smart/widgets/client_home/success.dart';
import 'package:smart/widgets/firebase_auth_imp/firebase_auth_services.dart';

class Cheques extends StatefulWidget {
  final String userId;

  const Cheques({
    required this.userId,
    super.key,
  });

  @override
  State<Cheques> createState() => _ChequesState();
}

class _ChequesState extends State<Cheques> {
  final vendorEmailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  /// List of images
  final List<File> _pickedImages = [];

  Future<void> _uploadCheques(String duration, List<File> files, String vendorEmail) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final userEmail = user != null ? user.email : '';

      // Get the directory for storing user files
      final userDir = await getApplicationDocumentsDirectory();
      final userFolderPath = '${userDir.path}/userFolders/$userEmail/cheques/$duration';
      final userFolder = Directory(userFolderPath);
      if (!userFolder.existsSync()) {
        userFolder.createSync(recursive: true);
      }

      // Get the directory for storing vendor files
      final vendorDir = await getApplicationDocumentsDirectory();
      final vendorFolderPath = '${vendorDir.path}/vendorFolders/$vendorEmail/cheques/$duration';
      final vendorFolder = Directory(vendorFolderPath);
      if (!vendorFolder.existsSync()) {
        vendorFolder.createSync(recursive: true);
      }

      for (File file in files) {
        final fileName = 'cheque_${DateTime.now().millisecondsSinceEpoch}.${file.path.split('.').last}';

        // Save the file to the user's folder
        final userFilePath = '$userFolderPath/$fileName';
        await file.copy(userFilePath);

        // Upload the file to Firebase Storage for the user
        final userStorageRef = firebase_storage.FirebaseStorage.instance
            .ref('userFolders/$userEmail/cheques/$duration/$fileName');
        await userStorageRef.putFile(file);

        // Copy the file to the vendor's folder
        final vendorFilePath = '$vendorFolderPath/$fileName';
        await file.copy(vendorFilePath);

        // Upload the file to Firebase Storage for the vendor
        final vendorStorageRef = firebase_storage.FirebaseStorage.instance
            .ref('vendorFolders/$vendorEmail/cheques/$duration/$fileName');
        await vendorStorageRef.putFile(file);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cheques for $duration months uploaded successfully!'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error uploading cheques: $e'),
        ),
      );
    }
  }

  Future<void> _pickAndUploadCheques(String duration) async {
    final vendorEmail = vendorEmailController.text;

    // Check if the vendor ID is not empty
    if (vendorEmail.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the Vendor Email'),
        ),
      );
      return;
    }

    // Check if the vendor ID exists
    bool vendorEmailExists = await FirebaseAuthService().checkVendorEmailExists(vendorEmail);
    if (!vendorEmailExists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vendor Email does not exist'),
        ),
      );
      return;
    }

    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'jpeg', 'pdf'],
    );

    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();
      setState(() {
        _pickedImages.addAll(files);
      });
      _uploadCheques(duration, files, vendorEmail);
    }
  }

  void _navigateToUploadSuccessScreen() {
    // Check if the form fields are valid
    if (vendorEmailController.text.isEmpty || !_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all the required fields'),
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ClientHome(),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const Success(),
      ),
    );
  }

  @override
  void dispose() {
    vendorEmailController.dispose();

    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: const Center(
            child: Text('Upload Cheques'),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 10,
          ),
          child: Center(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFileds(
                      controller: vendorEmailController,
                      label: 'Vendor Email',
                      obscure: false,
                      input: TextInputType.emailAddress,
                      validate: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the Vendor Email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20.0),
                    SizedBox(
                      width: double.infinity,
                      child: Button(
                        label: "Upload Cheques for 3 months",
                        onTap: () => _pickAndUploadCheques('3 months'),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Button(
                        label: "Upload Cheques for 6 months",
                        onTap: () => _pickAndUploadCheques('6 months'),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Button(
                        label: "Upload Cheques for 9 months",
                        onTap: () => _pickAndUploadCheques('9 months'),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        itemCount: _pickedImages.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Image.file(_pickedImages[index]),
                          );
                        },
                      ),
                    ),
                    Button(
                      label: 'Back To Home',
                      onTap: _navigateToUploadSuccessScreen,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
