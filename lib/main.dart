import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_metadata/homePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyStorageApp());
}

class MyStorageApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Sample App ',
      home: HomePage(),
    );
  }
}
