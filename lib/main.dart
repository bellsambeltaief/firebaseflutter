import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:smart/widgets/welcome/welcome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        appId: '1:113432771088:android:8b900409827cc1e4016895',
        apiKey: 'AIzaSyB8A7vaVFYjKuvED3bf86oxQzH_Nkl6e4M',
        projectId: 'smart-1924e',
        messagingSenderId: '113432771088',
        storageBucket:
            'https://console.firebase.google.com/project/smart-1924e/storage/smart-1924e.appspot.com/files'),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smarteco',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const Welcome(),
    );
  }
}
