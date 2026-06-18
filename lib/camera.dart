import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'dart:math' as math;

import 'models.dart';

typedef Callback = void Function(List<dynamic>? list, int h, int w, int inferenceTime);

class Camera extends StatefulWidget {
  final List<CameraDescription> cameras;
  final Callback setRecognitions;
  final String model;

  const Camera(this.cameras, this.model, this.setRecognitions, {super.key});

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  CameraController? controller;
  bool isDetecting = false;
  bool isDisposed = false;

  @override
  void initState() {
    super.initState();

    if (widget.cameras.isEmpty) {
      debugPrint('No camera is found');
    } else {
      controller = CameraController(
        widget.cameras[0],
        ResolutionPreset.high,
        enableAudio: false,
      );
      
      controller!.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});

        controller!.startImageStream((CameraImage img) {
          if (isDisposed) return;
          if (!isDetecting) {
            isDetecting = true;

            int startTime = DateTime.now().millisecondsSinceEpoch;

            List<Uint8List> bytesList = img.planes.map((plane) {
              return plane.bytes;
            }).toList();

            if (widget.model == mobilenet) {
              Tflite.runModelOnFrame(
                bytesList: bytesList,
                imageHeight: img.height,
                imageWidth: img.width,
                numResults: 2,
              ).then((recognitions) {
                int endTime = DateTime.now().millisecondsSinceEpoch;
                debugPrint("Detection took ${endTime - startTime}");

                widget.setRecognitions(recognitions, img.height, img.width, endTime - startTime);

                isDetecting = false;
              });
            } else if (widget.model == posenet) {
              Tflite.runPoseNetOnFrame(
                bytesList: bytesList,
                imageHeight: img.height,
                imageWidth: img.width,
                numResults: 2,
              ).then((recognitions) {
                int endTime = DateTime.now().millisecondsSinceEpoch;
                debugPrint("Detection took ${endTime - startTime}");

                widget.setRecognitions(recognitions, img.height, img.width, endTime - startTime);

                isDetecting = false;
              });
            } else {
              Tflite.detectObjectOnFrame(
                bytesList: bytesList,
                model: widget.model == yolo ? "YOLO" : "SSDMobileNet",
                imageHeight: img.height,
                imageWidth: img.width,
                imageMean: widget.model == yolo ? 0 : 127.5,
                imageStd: widget.model == yolo ? 255.0 : 127.5,
                numResultsPerClass: 1,
                threshold: widget.model == yolo ? 0.2 : 0.4,
              ).then((recognitions) {
                int endTime = DateTime.now().millisecondsSinceEpoch;
                debugPrint("Detection took ${endTime - startTime}");

                widget.setRecognitions(recognitions, img.height, img.width, endTime - startTime);

                isDetecting = false;
              });
            }
          }
        });
      });
    }
  }

  @override
  void dispose() {
    isDisposed = true;
    final currentController = controller;
    if (currentController != null && currentController.value.isStreamingImages) {
      currentController.stopImageStream();
    }
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentController = controller;
    if (currentController == null || !currentController.value.isInitialized) {
      return Container();
    }

    var tmp = MediaQuery.of(context).size;
    var screenH = math.max(tmp.height, tmp.width);
    var screenW = math.min(tmp.height, tmp.width);
    
    final previewSize = currentController.value.previewSize;
    if (previewSize == null) {
      return Container();
    }
    
    var previewH = math.max(previewSize.height, previewSize.width);
    var previewW = math.min(previewSize.height, previewSize.width);
    var screenRatio = screenH / screenW;
    var previewRatio = previewH / previewW;

    return OverflowBox(
      maxHeight:
          screenRatio > previewRatio ? screenH : screenW / previewW * previewH,
      maxWidth:
          screenRatio > previewRatio ? screenH / previewH * previewW : screenW,
      child: CameraPreview(currentController),
    );
  }
}
