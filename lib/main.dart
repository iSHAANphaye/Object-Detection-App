import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'home_screen.dart';

late final List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    debugPrint('Error: $e.code\nError Message: $e.message');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ObjectDetector - TFLite',
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: HomeScreen(cameras),
    );
  }
}

// C:\Users\ishaan phaye\Downloads\Compressed\flutter_realtime_detection-master\flutter_realtime_detection-master\lib\main.dart