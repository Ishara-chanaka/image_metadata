import 'dart:io';
import 'package:exif/exif.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _image;

  Future getImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imageTemporary = File(image.path);

      await getImageMetadata(image.path);

      //final imagePermanent = await saveFilePermanently(image.path);

      setState(() {
        _image = imageTemporary;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image $e');
    }
  }

  getImageMetadata(filePath) async {
    print(filePath);
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
      print("create Date - ${data['Image DateTime']}");
      print(await exifLatitudeLongitudePoint(data));
      print('----------------------');
    } catch (err) {
      print(err);
    }
  }

  exifLatitudeLongitudePoint(var data) async {
    if (data.containsKey('GPS GPSLongitude')) {
      final gpsLatitude = data['GPS GPSLatitude'];
      final latitudeSignal = data['GPS GPSLatitudeRef']!.printable;
      List latitudeRation = gpsLatitude!.values.toList();
      List latitudeValue = latitudeRation.map((item) {
        return (item.numerator.toDouble() / item.denominator.toDouble());
      }).toList();
      double latitude = latitudeValue[0] +
          (latitudeValue[1] / 60) +
          (latitudeValue[2] / 3600);
      if (latitudeSignal == 'S') latitude = -latitude;
      var latValue = latitude;

      final gpsLongitude = data['GPS GPSLongitude'];
      final longitudeSignal = data['GPS GPSLongitude']!.printable;
      List longitudeRation = gpsLongitude!.values.toList();
      List longitudeValue = longitudeRation.map((item) {
        return (item.numerator.toDouble() / item.denominator.toDouble());
      }).toList();
      double longitude = longitudeValue[0] +
          (longitudeValue[1] / 60) +
          (longitudeValue[2] / 3600);
      if (longitudeSignal == 'W') longitude = -longitude;
      var lngValue = longitude;

      return "lat - ${latValue}  long - ${lngValue} ";
    }
  }

  Future<File?> saveFilePermanently(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    final image = File('${directory.path}/$name');

    return File(imagePath).copy(image.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pick Image App'),
      ),
      body: Center(
        child: Column(children: [
          SizedBox(height: 40),
          _image != null
              ? Image.file(
                  File(_image!.path),
                  width: 250,
                  height: 250,
                  fit: BoxFit.cover,
                )
              : FlutterLogo(size: 250),
          SizedBox(height: 40),
          CustomButton(
            title: 'Pick from Gallery',
            icon: Icons.image_outlined,
            onClick: () => getImage(ImageSource.gallery),
          ),
          SizedBox(height: 40),
          CustomButton(
            title: 'Pick from Camera',
            icon: Icons.camera,
            onClick: () => getImage(ImageSource.camera),
          ),
        ]),
      ),
    );
  }
}

Widget CustomButton({
  required String title,
  required IconData icon,
  required VoidCallback onClick,
}) {
  return Container(
    width: 280,
    child: ElevatedButton(
      onPressed: onClick,
      child: Row(
        children: [
          Icon(icon),
          SizedBox(
            width: 20,
          ),
          Text(title)
        ],
      ),
    ),
  );
}
