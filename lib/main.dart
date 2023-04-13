import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'home.dart';

List<CameraDescription> cameras;

Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print('Error: $e.code\nError Message: $e.message');
  }
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ObjectDetector - TFLite',
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: HomePage(cameras),
    );
  }
}

// C:\Users\ishaan phaye\Downloads\Compressed\flutter_realtime_detection-master\flutter_realtime_detection-master\lib\main.dart