import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'dart:math' as math;

import 'camera.dart';
import 'bndbox.dart';
import 'models.dart';

class DetectionScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  final String model;

  const DetectionScreen({
    required this.cameras,
    required this.model,
    super.key,
  });

  @override
  State<DetectionScreen> createState() => _DetectionScreenState();
}

class _DetectionScreenState extends State<DetectionScreen> {
  List<dynamic> _recognitions = [];
  int _imageHeight = 0;
  int _imageWidth = 0;
  int _inferenceTime = 0;
  bool _modelLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    String? res;
    try {
      switch (widget.model) {
        case yolo:
          res = await Tflite.loadModel(
            model: "assets/yolov2_tiny.tflite",
            labels: "assets/yolov2_tiny.txt",
          );
          break;

        case mobilenet:
          res = await Tflite.loadModel(
              model: "assets/mobilenet_v1_1.0_224.tflite",
              labels: "assets/mobilenet_v1_1.0_224.txt");
          break;

        case posenet:
          res = await Tflite.loadModel(
              model: "assets/posenet_mv1_075_float_from_checkpoints.tflite");
          break;

        default:
          res = await Tflite.loadModel(
              model: "assets/ssd_mobilenet.tflite",
              labels: "assets/ssd_mobilenet.txt");
      }
      debugPrint("Model [${widget.model}] loaded successfully: $res");
      if (mounted) {
        setState(() {
          _modelLoaded = true;
        });
      }
    } catch (e) {
      debugPrint("Failed to load model: $e");
    }
  }

  void _setRecognitions(List<dynamic>? recognitions, int imageHeight, int imageWidth, int inferenceTime) {
    if (!mounted) return;
    setState(() {
      _recognitions = recognitions ?? [];
      _imageHeight = imageHeight;
      _imageWidth = imageWidth;
      _inferenceTime = inferenceTime;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_modelLoaded) {
      return const Scaffold(
        backgroundColor: Color(0xFF0D0F14),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF25D5FD)),
              ),
              SizedBox(height: 16),
              Text(
                "Initializing Neural Network...",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    Size screen = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Live Camera Stream
          Camera(
            widget.cameras,
            widget.model,
            _setRecognitions,
          ),
          
          // Bounding Box / Keypoints Drawing Overlay
          BndBox(
            _recognitions,
            math.max(_imageHeight, _imageWidth),
            math.min(_imageHeight, _imageWidth),
            screen.height,
            screen.width,
            widget.model,
          ),

          // Glassmorphic Back Button (Top-Left)
          Positioned(
            top: 16,
            left: 16,
            child: SafeArea(
              child: ClipOval(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(102),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withAlpha(38),
                        width: 1.5,
                      ),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Glassmorphic Bottom Performance Card
          Positioned(
            bottom: 24 + MediaQuery.of(context).viewPadding.bottom,
            left: 24,
            right: 24,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(140),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.white.withAlpha(30),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "ACTIVE MODEL",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF25D5FD),
                              letterSpacing: 1.0,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.model,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "INFERENCE SPEED",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFB13DFD),
                              letterSpacing: 1.0,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "$_inferenceTime ms",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: _inferenceTime < 100 
                                ? const Color(0xFF25FD8D) 
                                : (_inferenceTime < 300 ? Colors.orangeAccent : Colors.redAccent),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
