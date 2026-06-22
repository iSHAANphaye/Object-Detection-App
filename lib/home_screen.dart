import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'models.dart';
import 'detection_screen.dart';

class HomeScreen extends StatelessWidget {
  final List<CameraDescription> cameras;

  const HomeScreen(this.cameras, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            colors: [Color(0xFF1E2638), Color(0xFF0D0F14)],
            center: Alignment.center,
            radius: 1.2,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                // Heading area
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [Color(0xFF25D5FD), Color(0xFFB13DFD)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds),
                        child: const Text(
                          "Spectra Vision",
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.info_outline,
                        color: Color(0xFF25D5FD),
                        size: 32,
                      ),
                      onPressed: () => _showComparisonSheet(context),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  "Select a TFLite model to initiate real-time edge intelligence.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white60,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 36),
                // Grid of Model selection cards
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.75,
                    children: [
                      _buildModelCard(
                        context,
                        title: "SSD MobileNet",
                        subtitle: "Multi-object detection (80 classes)",
                        modelName: ssd,
                        icon: Icons.filter_center_focus,
                        startColor: const Color(0xFFFD7435),
                        endColor: const Color(0xFFFD3556),
                      ),
                      _buildModelCard(
                        context,
                        title: "Tiny YOLOv2",
                        subtitle: "High-speed real-time detection",
                        modelName: yolo,
                        icon: Icons.bolt,
                        startColor: const Color(0xFF25FD8D),
                        endColor: const Color(0xFF25CFD5),
                      ),
                      _buildModelCard(
                        context,
                        title: "MobileNet v1",
                        subtitle: "1000-class image classifier",
                        modelName: mobilenet,
                        icon: Icons.category_outlined,
                        startColor: const Color(0xFF259BFD),
                        endColor: const Color(0xFF9025FD),
                      ),
                      _buildModelCard(
                        context,
                        title: "PoseNet",
                        subtitle: "Human pose & skeleton estimator",
                        modelName: posenet,
                        icon: Icons.accessibility_new,
                        startColor: const Color(0xFFFD3D9D),
                        endColor: const Color(0xFFFD8C3D),
                      ),
                    ],
                  ),
                ),
                // Footer
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    "TensorFlow Lite • MSCOCO • Dart 3",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white30,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModelCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String modelName,
    required IconData icon,
    required Color startColor,
    required Color endColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [
            startColor.withAlpha(38),
            endColor.withAlpha(13),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: startColor.withAlpha(76),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: startColor.withAlpha(13),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetectionScreen(
                    cameras: cameras,
                    model: modelName,
                  ),
                ),
              );
            },
            splashColor: startColor.withAlpha(51),
            highlightColor: startColor.withAlpha(25),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Icon container
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: startColor.withAlpha(38),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: startColor.withAlpha(102),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      icon,
                      color: startColor,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Texts
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          subtitle,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white54,
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showComparisonSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: BoxDecoration(
                color: const Color(0xFF0D0F14).withAlpha(220),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                border: Border.all(
                  color: Colors.white.withAlpha(25),
                  width: 1.5,
                ),
              ),
              child: Column(
                children: [
                  // Handle bar
                  const SizedBox(height: 12),
                  Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(50),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Model Metrics & Analysis",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white70),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  ),
                  const Divider(color: Colors.white24, height: 24),
                  
                  // Content
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "COMPARATIVE MATRIX",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF25D5FD),
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Horizontal Scrollable Comparison Table
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Table(
                              defaultColumnWidth: const FixedColumnWidth(135),
                              border: TableBorder.all(
                                color: Colors.white.withAlpha(25),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              children: [
                                // Table Header Row
                                _buildTableRow([
                                  "Model",
                                  "Task",
                                  "Disk Size",
                                  "Speed",
                                  "Input Size",
                                ], isHeader: true),
                                
                                // Table Data Rows
                                _buildTableRow([
                                  "SSD MobileNet",
                                  "Object Detection",
                                  "4.2 MB",
                                  "Fast (~30ms)",
                                  "300 x 300",
                                ]),
                                _buildTableRow([
                                  "Tiny YOLOv2",
                                  "Object Detection",
                                  "44.9 MB",
                                  "Moderate (~120ms)",
                                  "416 x 416",
                                ]),
                                _buildTableRow([
                                  "MobileNet v1",
                                  "Classification",
                                  "16.9 MB",
                                  "Fastest (~15ms)",
                                  "224 x 224",
                                ]),
                                _buildTableRow([
                                  "PoseNet",
                                  "Pose Estimation",
                                  "5.0 MB",
                                  "Fast (~45ms)",
                                  "257 x 257",
                                ]),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 32),
                          const Text(
                            "MODEL DETAILS",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFB13DFD),
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Model details list
                          _buildModelDetailCard(
                            title: "SSD MobileNet v1",
                            description: "Single Shot Detector combined with MobileNet backbones. Extremely optimized for mobile processors, providing a great balance between accuracy (93% class accuracy) and latency (~30ms) for general-purpose object classification & bounding box localization.",
                            useCase: "Security tracking, multi-object counting, and real-time bounding box visualization.",
                            color: const Color(0xFFFD7435),
                          ),
                          const SizedBox(height: 16),
                          _buildModelDetailCard(
                            title: "Tiny YOLOv2",
                            description: "A compact version of the You Only Look Once detector. While faster on high-end edge systems, the Tiny YOLOv2 model file size is significantly larger (44.9 MB) and input resolution is higher (416x416), leading to a high memory footprint.",
                            useCase: "Rapid bounding box detection on devices equipped with high memory capacity.",
                            color: const Color(0xFF25FD8D),
                          ),
                          const SizedBox(height: 16),
                          _buildModelDetailCard(
                            title: "MobileNet v1 (Classifier)",
                            description: "A specialized classification model designed to categorize input frames into 1000 categories (from ImageNet). It does not draw bounding boxes, but categorizes the primary subject of the frame at blazing-fast speeds (~15ms).",
                            useCase: "Product scanner, scene recognition, and generic tag classification.",
                            color: const Color(0xFF259BFD),
                          ),
                          const SizedBox(height: 16),
                          _buildModelDetailCard(
                            title: "PoseNet",
                            description: "A pose estimator that predicts 17 key skeletal coordinates of human bodies in real-time. Extremely lightweight (5.0 MB) and fast (~45ms), allowing dynamic joint mapping and motion analysis directly on the device.",
                            useCase: "Fitness tracking, gesture controls, posture analysis, and motion gaming.",
                            color: const Color(0xFFFD3D9D),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  TableRow _buildTableRow(List<String> cells, {bool isHeader = false}) {
    return TableRow(
      decoration: BoxDecoration(
        color: isHeader ? Colors.white.withAlpha(20) : Colors.transparent,
      ),
      children: cells.map((cellText) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
          child: Text(
            cellText,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
              color: isHeader ? Colors.white : Colors.white70,
              fontSize: 13,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildModelDetailCard({
    required String title,
    required String description,
    required String useCase,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(10),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withAlpha(40),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.white70,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Best For: ",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                TextSpan(
                  text: useCase,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
