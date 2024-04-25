import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:file_picker/file_picker.dart';
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

  /// Function to upload
  Future<void> _uploadCheques(String duration, List<File> files) async {
    try {
      for (File file in files) {
        final fileName = 'cheque_${DateTime.now().millisecondsSinceEpoch}.${file.path.split('.').last}';
        await firebase_storage.FirebaseStorage.instance
            .ref('users/${widget.userId}/cheques/$duration/$fileName')
            .putFile(file);
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
      allowMultiple: true, // Allow multiple file selection
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'jpeg', 'pdf'],
    );

    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();
      setState(() {
        _pickedImages.addAll(files); // Add selected files to the list
      });
      _uploadCheques(duration, files);
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
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: const Center(
            child: Text('Upload Cheques'),
          ),
        ),
        body: Center(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: TextFormField(
                    controller: vendorEmailController,
                    decoration: InputDecoration(
                      labelText: 'Vendor Email',
                      border: const OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 10, 73, 167),
                          width: 2.0,
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the Vendor Email';
                      }
                      return null;
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _pickAndUploadCheques('3months'),
                  child: const Text('Upload Cheques for 3 months'),
                ),
                ElevatedButton(
                  onPressed: () => _pickAndUploadCheques('6months'),
                  child: const Text('Upload Cheques for 6 months'),
                ),
                ElevatedButton(
                  onPressed: () => _pickAndUploadCheques('9months'),
                  child: const Text('Upload Cheques for 9 months'),
                ),
                const SizedBox(height: 16.0),
                Expanded(
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
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _navigateToUploadSuccessScreen,
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
