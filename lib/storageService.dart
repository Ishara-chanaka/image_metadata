import 'dart:io';

import 'package:exif/exif.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebaseStorage;

class Storage {
  final firebaseStorage.FirebaseStorage storage =
      firebaseStorage.FirebaseStorage.instance;

  Future<void> uploadFile(
    String filePath,
    String fileName,
  ) async {
    File file = File(filePath);

    try {
      // final fileBytes = File(filePath).readAsBytesSync();
      // final data = await readExifFromBytes(fileBytes);

      final data = await readExifFromBytes(File(filePath).readAsBytesSync());

      print(data.entries);

      print('----------------------');
      for (final entry in data.entries) {
        print("${entry.key}: ${entry.value}");
      }
      // for (String key in data.keys) {
      //   print("-$key (${data[key]?.tagType}) : ${data[key]}");
      // }
      print('----------------------');
      print(data.length);
      print('----------------------');
    } catch (err) {
      print(err);
    }

    try {
      await storage.ref('test/$fileName').putFile(file);
    } on firebase_core.FirebaseException catch (e) {
      print(e);
    }
  }

  Future<firebaseStorage.ListResult> listFIles() async {
    firebaseStorage.ListResult results = await storage.ref('test').listAll();

    results.items.forEach((firebaseStorage.Reference ref) {
      print('FOund File : $ref');
    });
    return results;
  }

  Future<String> downloadURL(String imageName) async {
    String downloadURL = await storage.ref('test/$imageName').getDownloadURL();
    return downloadURL;
  }

  Future<dynamic> getmetaData(String imageName) async {
    var filepath = await storage.ref('test/$imageName').getDownloadURL();

    print('---------------');
    print(filepath);

    // final fileBytes = File(filepath).readAsBytesSync();
    // final data = await readExifFromBytes(fileBytes);

    //print(metadata.updated);

    // for (String key in data.keys) {
    //   print("-$key (${data[key]?.tagType}) : ${data[key]}");
    // }
    print('---------------');
  }
}
