import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'models.dart';

class BndBox extends StatelessWidget {
  final List<dynamic> results;
  final int previewH;
  final int previewW;
  final double screenH;
  final double screenW;
  final String model;

  const BndBox(
    this.results,
    this.previewH,
    this.previewW,
    this.screenH,
    this.screenW,
    this.model, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> renderBoxes() {
      return results.map((re) {
        final rect = re["rect"];
        if (rect == null) return const SizedBox.shrink();

        double xValue = (rect["x"] as num).toDouble();
        double wValue = (rect["w"] as num).toDouble();
        double yValue = (rect["y"] as num).toDouble();
        double hValue = (rect["h"] as num).toDouble();
        double scaleW, scaleH, x, y, w, h;

        if (screenH / screenW > previewH / previewW) {
          scaleW = screenH / previewH * previewW;
          scaleH = screenH;
          double difW = (scaleW - screenW) / scaleW;
          x = (xValue - difW / 2) * scaleW;
          w = wValue * scaleW;
          if (xValue < difW / 2) w -= (difW / 2 - xValue) * scaleW;
          y = yValue * scaleH;
          h = hValue * scaleH;
        } else {
          scaleH = screenW / previewW * previewH;
          scaleW = screenW;
          double difH = (scaleH - screenH) / scaleH;
          x = xValue * scaleW;
          w = wValue * scaleW;
          y = (yValue - difH / 2) * scaleH;
          h = hValue * scaleH;
          if (yValue < difH / 2) h -= (difH / 2 - yValue) * scaleH;
        }

        final confidence = ((re["confidenceInClass"] as num? ?? 0.0) * 100).toStringAsFixed(0);
        final detectedClass = re["detectedClass"] ?? "Unknown";

        return Positioned(
          left: math.max(0.0, x),
          top: math.max(0.0, y),
          width: w,
          height: h,
          child: Container(
            padding: const EdgeInsets.only(top: 5.0, left: 5.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color.fromRGBO(37, 213, 253, 1.0),
                width: 3.0,
              ),
            ),
            child: Text(
              "$detectedClass $confidence%",
              style: const TextStyle(
                color: Color.fromRGBO(37, 213, 253, 1.0),
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }).toList();
    }

    List<Widget> renderStrings() {
      double offset = -10;
      return results.map((re) {
        offset = offset + 14;
        final label = re["label"] ?? "Unknown";
        final confidence = ((re["confidence"] as num? ?? 0.0) * 100).toStringAsFixed(0);
        return Positioned(
          left: 10,
          top: offset,
          width: screenW,
          height: screenH,
          child: Text(
            "$label $confidence%",
            style: const TextStyle(
              color: Color.fromRGBO(37, 213, 253, 1.0),
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }).toList();
    }

    List<Widget> renderKeypoints() {
      final lists = <Widget>[];
      for (var re in results) {
        final keypoints = re["keypoints"];
        if (keypoints == null) continue;
        
        final list = (keypoints as Map).values.map<Widget>((k) {
          double xValue = (k["x"] as num).toDouble();
          double yValue = (k["y"] as num).toDouble();
          double scaleW, scaleH, x, y;

          if (screenH / screenW > previewH / previewW) {
            scaleW = screenH / previewH * previewW;
            scaleH = screenH;
            double difW = (scaleW - screenW) / scaleW;
            x = (xValue - difW / 2) * scaleW;
            y = yValue * scaleH;
          } else {
            scaleH = screenW / previewW * previewH;
            scaleW = screenW;
            double difH = (scaleH - screenH) / scaleH;
            x = xValue * scaleW;
            y = (yValue - difH / 2) * scaleH;
          }
          final part = k["part"] ?? "keypoint";
          return Positioned(
            left: x - 6,
            top: y - 6,
            width: 100,
            height: 12,
            child: Text(
              "● $part",
              style: const TextStyle(
                color: Color.fromRGBO(37, 213, 253, 1.0),
                fontSize: 12.0,
              ),
            ),
          );
        }).toList();

        lists.addAll(list);
      }

      return lists;
    }

    return Stack(
      children: model == mobilenet
          ? renderStrings()
          : model == posenet ? renderKeypoints() : renderBoxes(),
    );
  }
}
